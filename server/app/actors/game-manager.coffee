debug = require('debug')('sh:actor-manager')
_ = require('underscore')

Bacon = require('baconjs')

SocketActor = require('./socket-actor')
PlayerActor = require('./player-actor')
MapActor = require('./map-actor')
RocketActor = require('./rocket-actor')

class GameManager
  constructor: (@id) ->
    @actors = []
    @globalBus = new Bacon.Bus()
    @rocketCount = 0 # TODO: BETTER ROCKET ID!

    @createMapActor()
    @createSocketActor()

  # Collects state of all actors expect socket and returns it
  getGameState: ->
    _.map _.filter(@actors, (a) -> a.type != 'socket'), (a) ->
      type: a.type
      state: a.getState()

  getMapActor: ->
    _.find(@actors, (a) -> a.type == 'map')

  createMapActor: ->
    debug('Creating map actor')
    mapActor = new MapActor(@)
    @actors.push(mapActor)

  createSocketActor: ->
    debug('Creating socket actor')
    socketActor = new SocketActor(@)
    @actors.push(socketActor)

  createPlayerActor: (playerId) ->
    debug('Creating player actor')
    playerActor = new PlayerActor(@, playerId)
    @actors.push(playerActor)

  createRocketActor: (shooterId, x, y, direction) ->
    debug('Creating rocket actor')

    # TODO: BETTER ID!!
    rocketActor = new RocketActor(@, @rocketCount++, shooterId, x, y, direction)
    @actors.push(rocketActor)

  deletePlayerActor: (playerId) ->
    actor = _.find(@actors, (a) -> a.type == 'player' && a.id == playerId)
    if actor
      debug("Cleaning player actor #{actor.id}")
      actor.destroy()
      @actors = _.without(@actors, actor)
    else
      debug("Can't find player #{playerId}")

  deleteRocketActor: (rocketId) ->
    actor = _.find(@actors, (a) -> a.type == 'rocket' && a.id == rocketId)
    if actor
      debug("Destroying rocket actor #{actor.id}")
      actor.destroy()
      @actors = _.without(@actors, actor)
    else
      debug("Cant'find rocket #{rocketId}")

  getSocketActor: ->
    _.find(@actors, (a) -> a.type == 'socket')

  addPlayer: (socket) ->
    @getSocketActor().newConnection(socket)
    @createPlayerActor(socket.id)

module.exports = GameManager