mockery = require 'mockery'

{Daemon} = require '../src/daemon'
{Notification} = require 'inform-shared'
{MockPlugin} = require './mocks'
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
      expect(_on.calledWith "message").to.be.true
      expect(_on.firstCall.args.length).to.equal 2

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

  describe '#use', ->
    it 'should return a new plugin given a plugin module name', sinon.test ->
      pluginModule = @mock
      pluginModule.Plugin = MockPlugin

      mockery.registerMock 'plugin', pluginModule
      mockery.enable()

      daemon = new Daemon
      result = daemon.use 'plugin'

      expect(result instanceof pluginModule.Plugin).to.be.true

      mockery.disable()
      mockery.deregisterMock 'plugin'

    it 'should pass any provided options to the created plugin', sinon.test ->
      pluginModule = @mock
      pluginModule.Plugin = MockPlugin

      mockery.registerMock 'plugin', pluginModule
      mockery.enable()

      options = {}

      daemon = new Daemon
      result = daemon.use 'plugin', options

      expect(result.options).to.equal options

      mockery.disable()
      mockery.deregisterMock 'plugin'

