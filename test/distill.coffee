describe 'distill', ->
  Given -> @ctrls = spyObj('findControllerDir')
  Given -> @subject = sandbox 'lib/distill',
    './controllers': @ctrls

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
