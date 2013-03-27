zmq = require 'zmq'

class Daemon
  listen: ->
    socket = zmq.socket 'pull'
    socket.bindSync 'tcp://127.0.0.1:5000'

module.exports = {
  Daemon
}
