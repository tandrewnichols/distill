fs = require 'fs'
path = require 'path'
root = require.main.filename
_ = require 'underscore'
self = exports


exports.findControllerDir = (config) ->
  return root + "/" + (_([config.ctrlDir, 'controllers', 'routes']).find(self.exists) or self.ctrlError config)

exports.exists = (dir) ->
  if /^\//.test(dir) then return fs.existsSync dir else return fs.existsSync(path.resolve root, dir)

exports.ctrlError = (config) ->
  throw new Error """
    DistillException: Unable to locate controllers in #{config.ctrlDir}, controllers, or routes
    """
