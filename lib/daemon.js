const events = require('events'),
      lodash = require('lodash'),
      shared = require('inform-shared'),
      zmq = require('zeromq');


class InvalidPluginError extends Error {}

class Daemon extends events.EventEmitter {
  listen() {
    const socket = zmq.socket('pull');

    socket.bindSync('tcp://127.0.0.1:5000');
    socket.on('message', this.handle.bind(this));
  }

  handle(message) {
    const notification = new shared.Notification;
    notification.message = message;
    this.emit('message', this.normalize(notification));
  }

  normalize(notification) {
    return notification.get();
  }

  use(moduleName, options) {
    const pluginModule = require(moduleName),
          plugin = new pluginModule.Plugin(options);

    if (typeof plugin.receive === 'undefined')
      throw new InvalidPluginError(
        "Expected plugin to (" + module + ") define a receive method."
      );

    this.on('message', plugin.receive.bind(plugin));

    return plugin;
  }
}


module.exports = {
  InvalidPluginError,
  Daemon,
};
