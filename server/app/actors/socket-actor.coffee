debug = require('debug')('sh:socket-actor')
Bacon = require('baconjs')
_ = require('underscore')

class SocketActor
  constructor: (@manager) ->
    @type = 'socket'
    @sockets = []

    @bindEvents()

  bindEvents: ->
    @manager.globalBus.filter((ev) -> ev.type == 'START_LISTENING_SOCKETS').onValue @startListeningSockets
    @manager.globalBus.filter((ev) -> ev.type == 'SEND_TO_SOCKET').onValue @sendToSocket
    @manager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue @broadcast

  startListeningSockets: (ev) =>
    debug('Start listening for sockets')
    @io = ev.io
    @io.sockets.on 'connection', @newConnection

  broadcast: (ev) =>
    debug("Broadcasting to all clients")
    @io.sockets.in('all').emit(ev.key, ev.data)

  sendToSocket: (ev) =>
    socket = _.find @sockets, (s) -> s.id == ev.id
    if socket
      debug("Sending something to socket #{socket.id}")
      socket.emit(ev.key, ev.data)
    else
      debug("Unknown socket")

  bind: (socket, key) ->
    bus = new Bacon.Bus()
    socket.on key, (data) ->
      bus.push { socket: socket, key: key, data: data }
    bus

  newConnection: (socket) =>
    @sockets.push(socket)

    debug('Adding new connection to room "all"')
    socket.join('all')

    @manager.createPlayerActor(socket.id)
    gameState = @manager.getGameState()

    socket.emit('game-state', gameState)
    debug('Game state to new player sent')

    @bind(socket, 'player').onValue @handlePlayerEvent
    @bind(socket, 'disconnect').onValue @handleDisconnection

  handlePlayerEvent: (ev) =>
    switch ev.data.action
      when 'move' then @manager.globalBus.push { type: 'PLAYER_MOVE', direction: ev.data.direction, id: ev.socket.id }

  handleDisconnection: (ev) =>
    debug 'Got disconnection event. Cleaning up...'
    @manager.deletePlayerActor(ev.socket.id)

  getState: ->
    # Change to io-state
    'online'

module.exports = SocketActor
