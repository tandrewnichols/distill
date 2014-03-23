events = require 'events'
emitter = new events.EventEmitter()
helper = require './helper'
self = exports
$ = require 'varity'


#
# Possible options:
#   controllerDir
#   serviceDir
#   resourceDir
exports.config = $ 'of', (config, fn) ->
  self.config = config || {}
  self.config.configFn = fn if fn
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
