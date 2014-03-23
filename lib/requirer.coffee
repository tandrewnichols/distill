manifestBuilder = require 'file-manifest'
path = require 'path'
_ = require 'underscore'

exports.require = (dir) ->
  return manifestBuilder.generate dir, '**/*.js', (manifest, file) ->
    req = require @dir + '/' + file
    if req.name and req.controller
      manifest[req.name] = req.controller
    return manifest
