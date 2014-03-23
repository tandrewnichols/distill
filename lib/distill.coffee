manifestBuilder = require 'file-manifest'
events = require 'events'
emitter = new events.EventEmitter()
finder = require './finder'
requirer = require './requirer'
self = exports
$ = require 'varity'

#
# Possible options:
#   controllerDir
#   serviceDir
#   resourceDir
exports.config = $ 'of', (config, fn) ->
  self.config = config || {}
  fn?()

exports.run = (express, cb) ->
  app = express()
  definitions = requirer.require finder.findControllers(self.config.controllerDir), finder.findServices(self.config.serviceDir), finder.findResources(self.config.resourceDir)

exports.controller = (name, fn) ->
