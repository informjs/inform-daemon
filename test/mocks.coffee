sinon = require 'sinon'


class MockPlugin
  constructor: (@options) ->
    @receive = sinon.stub()


module.exports = {
  MockPlugin
}
