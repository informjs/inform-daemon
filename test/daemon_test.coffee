{Daemon} = require '../src/daemon'
{Notification} = require 'inform-shared'
{expect} = require 'chai'

sinon = require 'sinon'
zmq = require 'zmq'

notificationData = 'This is some example data.'

describe 'Daemon', ->
  describe '#listen', ->
    it 'should listen for messages using ØMQ', sinon.test ->
      bindSync = @spy()
      _on = @spy()

      @mock(zmq).expects('socket').withArgs('pull').once().returns
        bindSync: bindSync
        on: _on

      daemon = new Daemon
      daemon.listen()

      expect(bindSync.calledOnce).to.be.true
      expect(bindSync.firstCall.args.length).to.equal 1

    it 'should listen for "message" events on ØMQ sockets', sinon.test ->
      _on = @spy()

      @mock(zmq).expects('socket').withArgs('pull').once().returns
        bindSync: ->
        on: _on

      daemon = new Daemon
      daemon.listen()

      expect(_on.calledOnce).to.be.true
      expect(_on.calledWith "message", daemon.handle).to.be.true

  describe '#handler', ->
    it 'should trigger a "message" event providing #normalized data', sinon.test ->
      @spy Daemon.prototype, 'normalize'
      handler = @spy()

      # Use a Notification to translate our data into a message
      notification = new Notification notificationData
      daemon = new Daemon

      daemon.on 'message', handler
      daemon.handle notification.message

      expect(daemon.normalize.calledOnce).to.be.true

      expect(handler.calledOnce).to.be.true
      expect(handler.calledWith notificationData).to.be.true
      expect(handler.firstCall.args.length).to.equal 1


  describe '#normalize', ->
    it 'should normalize a Notification into usable data', ->
      notification = new Notification notificationData
      daemon = new Daemon

      expect(daemon.normalize notification).to.equal notificationData
