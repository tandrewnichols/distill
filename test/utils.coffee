root = require.main.filename

describe 'helper', ->
  Given -> @fs = spyObj 'existsSync'
  Given -> @path = spyObj 'resolve'
  Given -> @manifestBuilder = spyObj 'generate'
  Given -> @injectables =
    foo: 1
    bar: 2
  Given -> @subject = proxyquire '../lib/utils',
    fs: @fs
    './injectables': @injectables
    path: @path
    'file-manifest': @manifestBuilder
    'undefined/foo':
      '@noCallThru': true
    'undefined/bar':
      name: 'Bar'
      controller: 'controller'
      '@noCallThru': true
    'undefined/baz':
      name: 'Baz'
      middleware: 'middleware'
      '@noCallThru': true
    'undefined/quux':
      name: 'Quux'
      hello: 'world'
      foo: 'bar'
      '@noCallThru': true
    'undefined/blah':
      name: 'Blah'
      some: 'resource'
      '@noCallThru': true

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
    And -> @fn = @manifestBuilder.generate.getCall(0).args[2]

    context 'non-export form', ->
      When -> @manifest = @fn {}, 'foo'
      Then -> expect(@manifest).to.deeply.equal {}

    context 'with controller', ->
      When -> @manifest = @fn {}, 'bar'
      Then -> expect(@manifest).to.deeply.equal
        Bar: 'controller'

    context 'with middleware', ->
      When -> @manifest = @fn {}, 'baz'
      Then -> expect(@manifest).to.deeply.equal
        Baz: 'middleware'

    context 'with a service', ->
      When -> @manifest = @fn {}, 'quux'
      Then -> expect(@manifest).to.deeply.equal
        Quux:
          hello: 'world'
          foo: 'bar'
          '@noCallThru': true

    context 'with a resouce', ->
      When -> @manifest = @fn {}, 'blah'
      Then -> expect(@manifest).to.deeply.equal
        Blah:
          some: 'resource'
          '@noCallThru': true

  describe '.inspect', ->
    When -> @deps = @subject.inspect (foo, bar) ->
    Then -> expect(@deps).to.deeply.equal [ 'foo', 'bar' ]

  describe '.inject', ->
    When -> @injectables = @subject.inject [ 'foo', 'bar' ]
    Then -> expect(@injectables).to.deeply.equal [1, 2]
