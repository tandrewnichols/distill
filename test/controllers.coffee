root = require.main.filename

describe 'controllers', ->
  Given -> @fs = spyObj('existsSync')
  Given -> @path = spyObj('resolve')
  Given -> @subject = sandbox 'lib/controllers',
    fs: @fs
    path: @path

  Given -> @path.resolve.withArgs(root, "blah").returns "#{root}/blah"
  Given -> @path.resolve.withArgs(root, "controllers").returns "#{root}/controllers"
  Given -> @path.resolve.withArgs(root, "routes").returns "#{root}/routes"
  Given -> @withBlah = @fs.existsSync.withArgs("#{root}/blah")
  Given -> @withCtrls = @fs.existsSync.withArgs("#{root}/controllers")
  Given -> @withRoutes = @fs.existsSync.withArgs("#{root}/routes")

  context 'config dir exists and should beat controllers and routes', ->
    Given -> @config =
      ctrlDir: 'blah'
    Given -> @withBlah.returns true
    Given -> @withCtrls.returns true
    Given -> @withRoutes.returns true
    When -> @dir = @subject.findControllerDir(@config)
    Then -> expect(@dir).to.equal "#{root}/blah"

  context 'controllers exists and should beat routes', ->
    Given -> @config =
      ctrlDir: 'blah'
    Given -> @withBlah.returns false
    Given -> @withCtrls.returns true
    Given -> @withRoutes.returns true
    When -> @dir = @subject.findControllerDir(@config)
    Then -> expect(@dir).to.equal "#{root}/controllers"

  context 'routes exists', ->
    Given -> @config =
      ctrlDir: 'blah'
    Given -> @withBlah.returns false
    Given -> @withCtrls.returns false
    Given -> @withRoutes.returns true
    When -> @dir = @subject.findControllerDir(@config)
    Then -> expect(@dir).to.equal "#{root}/routes"

  context 'none exists', ->
    Given -> @config =
      ctrlDir: 'blah'
    Given -> @withBlah.returns false
    Given -> @withCtrls.returns false
    Given -> @withRoutes.returns false
    Then -> expect(@subject.findControllerDir).with(@config).to.throw "DistillException: Unable to locate controllers in blah, controllers, or routes"

  context 'no config', ->
    Given -> @withCtrls.returns true
    Given -> @withRoutes.returns true
    When -> @dir = @subject.findControllerDir({})
    Then -> expect(@dir).to.equal "#{root}/controllers"
