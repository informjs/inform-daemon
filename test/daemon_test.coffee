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

    it 'should accept a callback argument for handling messages', sinon.test ->
      bindSync = sinon.spy()
      _on = sinon.spy()

      callback = sinon.spy()

      @mock(zmq).expects('socket').withArgs('pull').once().returns
        bindSync: bindSync
        on: _on

      daemon = new Daemon
      daemon.listen callback

      expect(_on.calledOnce).to.be.true
      expect(_on.firstCall.args.length).to.equal 2
      expect(_on.firstCall.args[0]).to.equal 'message'
      expect(_on.firstCall.args[1]).to.equal callback
