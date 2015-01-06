ROT = require('../vendor/rot.js/rot')
Bacon = require('baconjs')

class Input
  BACKSPACE_KEYCODE = 8
  ENTER_KEYCODE = 13

  constructor: ({@display, @controller, @location}) ->
    @destruct = new Bacon.Bus()

    @text = ""
    @returnValue = $.Deferred()
    @input = @controller.onInput().takeUntil(@destruct)

    @returnValue.done => @destructor()

    @bindKeyPresses()
    @render()

  bindKeyPresses: ->
    @input.filter (keyCode) ->
      # Only allow ascii characters
      keyCode >= 32 && keyCode <= 126
    .onValue (keyCode) =>
      char = String.fromCharCode(keyCode)
      @text += char
      @render()

    @input.filter((keyCode) -> keyCode == BACKSPACE_KEYCODE).onValue =>
      @text = @text[0...@text.length - 1]
      @display.draw(@location.x + @text.length + 1, @location.y, " ")
      @render()

    @input.filter((keyCode) -> keyCode == ENTER_KEYCODE).onValue =>
      @returnValue.resolve(@text)

  render: ->
    # drawText is NOT suitable for this. It trims text and does all kinds of funny business
    for char, i in @text
      @display.draw(@location.x + i, @location.y, char)
    @display.draw(@text.length + @location.x, @location.y, "█")

  destructor: -> @destruct.push(true)

  value: ->
    @returnValue.promise()

module.exports = Input
