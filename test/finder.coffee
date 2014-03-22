root = require.main.filename

describe 'controllers', ->
  Given -> @fs = spyObj('existsSync')
  Given -> @path = spyObj('resolve')
  Given -> @subject = sandbox 'lib/finder',
    fs: @fs
    path: @path

  describe '.findControllers', ->
    Given -> @path.resolve.withArgs(root, "blah").returns "#{root}/blah"
    Given -> @path.resolve.withArgs(root, "controllers").returns "#{root}/controllers"
    Given -> @path.resolve.withArgs(root, "routes").returns "#{root}/routes"
    Given -> @withBlah = @fs.existsSync.withArgs("#{root}/blah")
    Given -> @withCtrls = @fs.existsSync.withArgs("#{root}/controllers")
    Given -> @withRoutes = @fs.existsSync.withArgs("#{root}/routes")

    context 'config dir exists and should beat controllers and routes', ->
      Given -> @withBlah.returns true
      Given -> @withCtrls.returns true
      Given -> @withRoutes.returns true
      When -> @dir = @subject.findControllers 'blah'
      Then -> expect(@dir).to.equal "#{root}/blah"

    context 'controllers exists and should beat routes', ->
      Given -> @withBlah.returns false
      Given -> @withCtrls.returns true
      Given -> @withRoutes.returns true
      When -> @dir = @subject.findControllers 'blah'
      Then -> expect(@dir).to.equal "#{root}/controllers"

    context 'routes exists', ->
      Given -> @withBlah.returns false
      Given -> @withCtrls.returns false
      Given -> @withRoutes.returns true
      When -> @dir = @subject.findControllers 'blah'
      Then -> expect(@dir).to.equal "#{root}/routes"

    context 'none exists', ->
      Given -> @withBlah.returns false
      Given -> @withCtrls.returns false
      Given -> @withRoutes.returns false
      Then -> expect(@subject.findControllers).with('blah').to.throw new Error "DistillException: Unable to locate controllers in 'controllers' or 'routes' and 'blah' from config did not exist."

    context 'no config', ->
      Given -> @withCtrls.returns true
      Given -> @withRoutes.returns true
      When -> @dir = @subject.findControllers {}
      Then -> expect(@dir).to.equal "#{root}/controllers"

    context 'no config error', ->
      Given -> @withCtrls.returns false
      Given -> @withRoutes.returns false
      Then -> expect(@subject.findControllers).to.throw new Error "DistillException: Unable to locate controllers in 'controllers' or 'routes' and no directory was passed in config."

  describe '.findResources', ->
    Given -> @path.resolve.withArgs(root, "blah").returns "#{root}/blah"
    Given -> @path.resolve.withArgs(root, "resources").returns "#{root}/resources"
    Given -> @withBlah = @fs.existsSync.withArgs("#{root}/blah")
    Given -> @withResources = @fs.existsSync.withArgs("#{root}/resources")

    context 'config dir exists and should beat resources', ->
      Given -> @withBlah.returns true
      Given -> @withResources.returns true
      When -> @dir = @subject.findResources 'blah'
      Then -> expect(@dir).to.equal "#{root}/blah"

    context 'resources exists', ->
      Given -> @withBlah.returns false
      Given -> @withResources.returns true
      When -> @dir = @subject.findResources 'blah'
      Then -> expect(@dir).to.equal "#{root}/resources"

    context 'none exists', ->
      Given -> @withBlah.returns false
      Given -> @withResources.returns false
      Then -> expect(@subject.findResources).with('blah').to.throw new Error "DistillException: Unable to locate resources in 'resources' and 'blah' from config did not exist."

    context 'no config', ->
      Given -> @withResources.returns true
      When -> @dir = @subject.findResources {}
      Then -> expect(@dir).to.equal "#{root}/resources"

    context 'no config error', ->
      Given -> @withResources.returns false
      Then -> expect(@subject.findResources).to.throw new Error "DistillException: Unable to locate resources in 'resources' and no directory was passed in config."
