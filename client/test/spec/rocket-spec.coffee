expect = require('chai').expect

ROT = require('../client/vendor/rot.js/rot')
Bacon= require('baconjs')
Rocket = require('../client/rocket')
Player = require('../client/player')

describe 'Rocket', ->
  beforeEach ->
    shooter = new Player("manny", "white", 0, 0)
    @rocket = new Rocket(0, 1, 1, shooter, 'right')

  it 'should have correct char when flying horizontally', ->
    expect(@rocket.getChar()).to.be.equal '-'

  it 'should have correct char when flying vertically', ->
    @rocket.direction = 'down'
    expect(@rocket.getChar()).to.be.equal '|'

  it 'should render rocket', (done) ->
    mockDisplay =
      draw: (x, y, char) ->
        expect(char).to.be.equal '-'
        done()
    @rocket.render(mockDisplay)

  it 'should move rocket to new position if possible', ->
    @rocket.newX = 2
    @rocket.newY = 1
    @rocket.handleNewPosition { draw: -> }
    expect(@rocket.x).to.be.equal(2)
    expect(@rocket.y).to.be.equal(1)

  it 'should clear current position if new position exists', ->
    @rocket.newX = 2
    drawSpy = sinon.spy()
    @rocket.handleNewPosition { draw: drawSpy }
    expect(drawSpy.called).to.be.true
    expect(drawSpy.firstCall.args[0]).to.be.equals(1)
    expect(drawSpy.firstCall.args[2]).to.be.equals('.')

