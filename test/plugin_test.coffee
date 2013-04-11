{Plugin} = require '../src/plugin'

sinon = require 'sinon'
{expect} = require 'chai'

exampleData =
  options: {
    example: 'options',
    go: [
      'here, ',
      'here, ',
      'or here'
    ]
  }

describe 'Plugin', ->
  describe '#constructor', ->
    it 'should set options to the first provided argument', sinon.test ->
      plugin = new Plugin exampleData.options

      expect(plugin.options).to.deep.equal exampleData.options

