events = require 'events'
emitter = new events.EventEmitter()
helper = require './helper'
self = exports
$ = require 'varity'
extend = require 'config-extend'

#
# Possible options:
#   controllerDir
#   serviceDir
#   resourceDir
exports.config = $ 'of', (config, fn) ->
  self.config = config || {}
  self.config.configFn = fn if fn
  self.config.locations =
    controllers: (self.config.locations.controllers or []).concat ['controllers', 'routes']
    services: (self.config.locations.services or []).concat ['services', 'lib']
    resources: (self.config.locations.resources or []).concat ['resources']
    middleware: (self.config.locations.resources or []).concat ['middleware']
  return self

exports.run = (express, cb) ->
  app = express()

exports.register = (type, list) ->
  _.chain().keys().each (name) ->
    self[type] name, list[name]

exports.controller = (name, fn) ->

exports.service = (name, fn) ->

exports.resource = (name, fn) ->

exports.middleware = (name, fn) ->
