{EventEmitter} = require 'events'
{Notification} = require 'inform-shared'

_ = require 'lodash'
zmq = require 'zmq'

class Daemon extends EventEmitter
  listen: (callback) ->
    socket = zmq.socket 'pull'
    socket.bindSync 'tcp://127.0.0.1:5000'

    if callback?
      socket.on 'message', callback

  handle: (message) ->
    notification = new Notification
    notification.message = message

    @emit 'message', @normalize notification

  normalize: (notification) -> notification.get()

module.exports = {
  Daemon
}
