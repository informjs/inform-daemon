{EventEmitter} = require 'events'
{Notification} = require 'inform-shared'

_ = require 'lodash'
zmq = require 'zmq'

class InvalidPluginError extends Error

class Daemon extends EventEmitter
  listen: ->
    socket = zmq.socket 'pull'
    socket.bindSync 'tcp://127.0.0.1:5000'

    socket.on 'message', @handle.bind @

  handle: (message) ->
    notification = new Notification
    notification.message = message

    @emit 'message', @normalize notification

  normalize: (notification) -> notification.get()

  use: (pluginModule, options) ->
    {Plugin} = require pluginModule

    plugin = new Plugin options

    unless plugin.receive?
      throw new InvalidPluginError "Expected plugin (#{ pluginModule }) define a receive method."

    @on 'message', plugin.receive.bind plugin

    return plugin

module.exports = {
  Daemon
  InvalidPluginError
}
