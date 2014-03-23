describe 'distill', ->
  Given -> @helper = spyObj 'find', 'require', 'inspect'
  Given -> @subject = sandbox 'lib/distill',
    './helper': @helper

  describe '.config', ->

  describe '.run', ->
