manifestBuilder = require 'file-manifest'
events = require 'events'
emitter = new events.EventEmitter()
ctrls = require './controllers'
self = exports
$ = require 'varity'

exports.config = $ 'of', (config, fn) ->
  self.config = config || {}
  fn?()

exports.run = (express, cb) ->
  app = express()
  ctrlDir = ctrls.findCtrlDir self.config
