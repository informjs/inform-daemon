{Notification} = require 'inform-shared'
zmq = require 'zmq'

class Daemon
  listen: (callback) ->
    socket = zmq.socket 'pull'
    socket.bindSync 'tcp://127.0.0.1:5000'

    if callback?
      socket.on 'message', callback

  handle: (callback, message) ->
    notification = new Notification
    notification.message = message

    callback @normalize notification

  normalize: (notification) -> notification.get()

module.exports = {
  Daemon
}
