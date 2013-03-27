{Daemon} = require '../src/daemon'
{expect} = require 'chai'

sinon = require 'sinon'
zmq = require 'zmq'

describe 'Daemon', ->
  describe '#listen', ->
    it 'should listen for messages using ØMQ', sinon.test ->
      bindSync = sinon.spy()

      @mock(zmq).expects('socket').withArgs('pull').once().returns
        bindSync: bindSync

      daemon = new Daemon
      daemon.listen()

      expect(bindSync.calledOnce).to.be.true
      expect(bindSync.firstCall.args.length).to.equal 1
