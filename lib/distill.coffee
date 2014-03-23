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
  self.register 'controller', finder.findController(self.config.controllerDir)
  self.register 'service', finder.findServices(self.config.serviceDir)
  self.register 'resource', finder.findResources(self.config.resourceDir)
  self.register 'middleware', finder.findMiddleware(self.config.middlewareDir)

exports.register = (type, list) ->
  _.chain().keys().each (name) ->
    self[type] name, list[name]

exports.controller = (name, fn) ->

exports.service = (name, fn) ->

exports.resource = (name, fn) ->

exports.middleware = (name, fn) ->
