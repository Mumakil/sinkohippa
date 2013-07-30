KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Player
  constructor: (@name, @x, @y) ->

  getChar: ->
    '@'

  render: (display) ->
    display.draw(@x, @y, @getChar())

  getMoveEvent: (direction) ->
    target: 'server'
    data:
      key: 'player'
      data:
        action: 'move'
        direction: direction

  moveUp: ->
    @y--
    gameEvents.globalBus.push @getMoveEvent('up')
  moveDown: ->
    @y++
    gameEvents.globalBus.push @getMoveEvent('down')
  moveRight: ->
    @x++
    gameEvents.globalBus.push @getMoveEvent('right')
  moveLeft: ->
    @x--
    gameEvents.globalBus.push @getMoveEvent('left')

  initButtons: ->
    keyboardController = new KeyboardController()
    keyboardController.bind('h').onValue => @moveLeft()
    keyboardController.bind('j').onValue => @moveDown()
    keyboardController.bind('k').onValue => @moveUp()
    keyboardController.bind('l').onValue => @moveRight()

module.exports = Player
