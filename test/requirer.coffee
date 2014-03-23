describe 'requirer', ->
  Given -> @manifestBuilder = spyObj 'generate'
  Given -> @controller = sinon.spy()
  Given -> @subject = sandbox 'lib/requirer',
    'file-manifest': @manifestBuilder
    'undefined/foo': {}
    'undefined/bar':
      name: 'Bar'
      controller: @controller

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
