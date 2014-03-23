describe 'distill', ->
  Given -> @helper = spyObj 'find', 'require', 'inspect'
  Given -> @subject = sandbox 'lib/distill',
    './helper': @helper

  describe '.config', ->
    context 'with config obj', ->
      Given -> @config =
        foo: 'bar'
      When -> @res = @subject.config @config
      Then -> expect(@subject.config).to.deeply.equal @config
      And -> expect(@res).to.equal @subject

    context 'with function', ->
      Given -> @fn = sinon.spy()
      When -> @res = @subject.config @fn
      Then -> expect(@subject.config).to.deeply.equal
        configFn: @fn
      And -> expect(@res).to.equal @subject

    context 'with both', ->
      Given -> @config =
        foo: 'bar'
      Given -> @fn = sinon.spy()
      When -> @res = @subject.config @config, @fn
      Then -> expect(@subject.config).to.deeply.equal
        foo: 'bar'
        configFn: @fn
      And -> expect(@res).to.equal @subject

  describe '.run', ->
