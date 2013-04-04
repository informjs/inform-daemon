{EventEmitter} = require 'events'
{Notification} = require 'inform-shared'

_ = require 'lodash'
zmq = require 'zmq'

class Daemon extends EventEmitter
  listen: ->
    socket = zmq.socket 'pull'
    socket.bindSync 'tcp://127.0.0.1:5000'

    socket.on 'message', (message) =>
      @handle message

  handle: (message) ->
    notification = new Notification
    notification.message = message

    @emit 'message', @normalize notification

  normalize: (notification) -> notification.get()

module.exports = {
  Daemon
}
