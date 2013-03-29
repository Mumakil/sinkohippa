console.log('Overriding main.js');
require.config({
  shim: {
    mocha: {
      exports: 'mocha'
    },
    sinon: {
      exports: 'sinon'
    }
  },
  paths: {
    mocha: '../lib/mocha/mocha',
    'chai-helper': '../helper/chai-helper',
    chai: '../lib/chai',
    sinon: '../lib/sinon-1.5.2',
  }
});

require(['mocha'], function(mocha) {
  'use strict';
  mocha.setup('bdd');
  require(
    ['../spec/game-spec'
    ], function() {
      require(['../runner/mocha']);
  });
});