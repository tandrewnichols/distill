root = require.main.filename

describe 'helper', ->
  Given -> @fs = spyObj('existsSync')
  Given -> @path = spyObj('resolve')
  Given -> @manifestBuilder = spyObj 'generate'
  Given -> @controller = sinon.spy()
  Given -> @subject = sandbox 'lib/helper',
    fs: @fs
    path: @path
    'file-manifest': @manifestBuilder
    'undefined/foo': {}
    'undefined/bar':
      name: 'Bar'
      controller: @controller

  describe '.find', ->
    Given -> @path.resolve.withArgs(root, "foo").returns "#{root}/foo"
    Given -> @path.resolve.withArgs(root, "bar").returns "#{root}/bar"
    Given -> @foo = @fs.existsSync.withArgs("#{root}/foo")
    Given -> @bar = @fs.existsSync.withArgs("#{root}/bar")

    context 'first exists', ->
      Given -> @foo.returns true
      Given -> @bar.returns true
      When -> @dir = @subject.find ['foo', 'bar']
      Then -> expect(@dir).to.equal "#{root}/foo"

    context 'second exists', ->
      Given -> @foo.returns false
      Given -> @bar.returns true
      When -> @dir = @subject.find ['foo', 'bar']
      Then -> expect(@dir).to.equal "#{root}/bar"

    context 'neither exists', ->
      Given -> @foo.returns false
      Given -> @bar.returns false
      When -> @dir = @subject.find ['foo', 'bar']
      Then -> expect(@dir).to.equal ""

  describe '.require', ->
    When -> @res = @subject.require 'foo'

    context 'no name or controller', ->
      When -> @fn = @manifestBuilder.generate.getCall(0).args[2]
      And -> @manifest = @fn {}, 'foo'
      Then -> expect(@manifest).to.deeply.equal {}

    context 'name and controller', ->
      When -> @fn = @manifestBuilder.generate.getCall(0).args[2]
      And -> @manifest = @fn {}, 'bar'
      Then -> expect(@manifest).to.deeply.equal
        Bar: @controller

  describe '.inspect', ->
    When -> @deps = @subject.inspect (foo, bar) ->
    Then -> expect(_.fix(@deps)).to.deeply.equal [ 'foo', 'bar' ]
