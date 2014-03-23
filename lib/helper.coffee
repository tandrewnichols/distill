fs = require 'fs'
path = require 'path'
root = require.main.filename
_ = require 'underscore'
manifestBuilder = require 'file-manifest'

exports.find = (list) ->
  location = _(list).find (dir) ->
    if /^\//.test(dir) then return fs.existsSync dir else return fs.existsSync(path.resolve root, dir)
  if location then "#{root}/#{location}" else ""

exports.require = (dir) ->
  return manifestBuilder.generate dir, '**/*.js', (manifest, file) ->
    req = require @dir + '/' + file
    if req.name
      if req.controller
        manifest[req.name] = req.controller
      else if req.middleware
        manifest[req.name] = req.middleware
      else
        # services and resources
        manifest[req.name] = _(req).omit('name')
    return manifest

exports.inspect = (fn) ->
  fn.toString().match(/^function\s*\(([^\)]*)/)[1].split(/,\s*/)
