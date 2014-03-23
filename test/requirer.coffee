describe 'requirer', ->
  Given -> @manifestBuilder = spyObj 'generate'
  Given -> @subject = sandbox 'lib/requirer',
    'file-manifest': @manifestBuilder

  Given -> @manifestBuilder.generate.withArgs('foo', '**/*.js').returns fooThing: 'foo'
  Given -> @manifestBuilder.generate.withArgs('bar', '**/*.js').returns barThing: 'bar'
  Given -> @manifestBuilder.generate.withArgs('baz', '**/*.js').returns bazThing: 'baz'
  When -> @res = @subject.require 'foo', 'bar', 'baz'
  Then -> expect(@res).to.deeply.equal
    foo:
      fooThing: 'foo'
    bar:
      barThing: 'bar'
    baz:
      bazThing: 'baz'
