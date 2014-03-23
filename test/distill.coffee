describe 'distill', ->
  Given -> @finder = spyObj('findControllers', 'findServices', 'findResources')
  Given -> @requirer = spyObj('require')
  Given -> @subject = sandbox 'lib/distill',
    './finder': @finder
    './requirer': @requirer

  describe '.config', ->
    context 'with config obj', ->
      Given -> @config =
        foo: 'bar'
      When -> @subject.config @config
      Then -> expect(@subject.config).to.deeply.equal @config

    context 'with function', ->
      Given -> @fn = sinon.spy()
      When -> @subject.config @fn
      Then -> expect(@fn).to.have.been.called
      And -> expect(@subject.config).to.deeply.equal {}

  describe '.run', ->
    Given -> @finder.findControllers.returns 'controllers'
    Given -> @finder.findServices.returns 'services'
    Given -> @finder.findResources.returns 'resources'
    #Given -> @requirer.require.returns
