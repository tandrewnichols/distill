exports.inspect = (fn) ->
  fn.toString().match(/^function\s*\(([^\)]*)/)[1].split(/,\s*/)
