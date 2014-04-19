describe 'distill', ->
  Given -> @utils = spyObj 'find', 'require', 'inspect'
  Given -> @subject = proxyquire '../lib/distill',
    './utils': @utils

  describe '.config', ->

  describe '.run', ->
