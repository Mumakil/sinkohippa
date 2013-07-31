KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Player
  constructor: (@id, @x, @y) ->

  getChar: ->
    '@'

  render: (display) ->
    @handleNewPosition(display)
    display.draw(@x, @y, @getChar())

  clearCurrentPosition: (display) ->
    # Assume that player can't stand inside the wall. This might need improving
    display.draw(@x, @y, '.')

  handleNewPosition: (display) ->
    if @newX or @newY
      @clearCurrentPosition(display)
      @x = @newX
      @y = @newY
      delete @newX
      delete @newY

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
    console.log("Turning on buttons!")
    keyboardController = new KeyboardController()
    keyboardController.bind('h').onValue => @moveLeft()
    keyboardController.bind('j').onValue => @moveDown()
    keyboardController.bind('k').onValue => @moveUp()
    keyboardController.bind('l').onValue => @moveRight()

module.exports = Player
