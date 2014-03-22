fs = require 'fs'
path = require 'path'
root = require.main.filename
_ = require 'underscore'

exports.findControllers = (ctrlDir) ->
  return new Finder('controllers', ctrlDir, ['controllers', 'routes']).find()

exports.findResources = (resourceDir) ->
  return new Finder('resources', resourceDir, ['resources']).find()

class Finder
  constructor: (@type, @configDir, @list) ->

  find: ->
    dir = _([@configDir].concat(@list)).find(@exists)
    if not dir
      throw new Error "DisitllException: Unable to locate #{@type} in #{@buildLocations()} and #{@buildMsgEnd()}."
    return "#{root}/#{dir}"
    
  exists: (dir) ->
    if /^\//.test(dir) then return fs.existsSync dir else return fs.existsSync(path.resolve root, dir)

  buildLocations: ->
    switch @list.length
      when 1 then "'#{@list[0]}'"
      when 2 then "'#{@list[0]}' or '#{@list[1]}'"
      else
        last = @list.pop()
        "'#{@list.join('\', \'')}', or '#{last}'"

  buildMsgEnd: ->
    if @configDir then "'#{@configDir}' from config did not exist" else "no directory was passed in config"
