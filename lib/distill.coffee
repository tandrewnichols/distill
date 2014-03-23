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
  controllers = finder.findController(self.config.controllerDir)
  _.chain().keys().each (name) ->
    self.controller name, controllers[name]

exports.controller = (name, fn) ->
