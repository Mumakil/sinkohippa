console.log 'Overriding mainjs'

mocha.setup('bdd')

require('../spec/game-spec')
require('../spec/map-spec')
require('../spec/player-spec')

mocha.run()
