manifestBuilder = require 'file-manifest'
path = require 'path'
_ = require 'underscore'

exports.require = (dirs...) ->
  _(dirs).reduce (memo, dir) ->
    memo[dir] = manifestBuilder.generate dir, '**/*.js'
    memo
  , {}

