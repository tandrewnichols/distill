describe 'inspector', ->
  Given -> @subject = sandbox 'lib/inspector'

  When -> @deps = @subject.inspect (foo, bar) ->
  Then -> expect(_.fix(@deps)).to.deeply.equal [ 'foo', 'bar' ]
