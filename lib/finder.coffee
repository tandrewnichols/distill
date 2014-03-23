fs = require 'fs'
path = require 'path'
root = require.main.filename
_ = require 'underscore'

exports.findControllers = (ctrlDir) ->
  return new Finder(ctrlDir, ['controllers', 'routes']).find()

exports.findResources = (resourceDir) ->
  return new Finder(resourceDir, ['resources']).find()

exports.findServices = (serviceDir) ->
  return new Finder(serviceDir, ['services', 'lib']).find()

exports.findMiddleware = (middlewareDir) ->
  return new Finder(middlewareDir, ['middleware']).find()

class Finder
  constructor: (@configDir, @list) ->

  find: ->
    dir = _([@configDir].concat(@list)).find(@exists)
    if dir then "#{root}/#{dir}" else ""
    
  exists: (dir) ->
    if /^\//.test(dir) then return fs.existsSync dir else return fs.existsSync(path.resolve root, dir)
