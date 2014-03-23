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
      Then -> expect(@subject.findResources()).to.equal ''

    context 'no config', ->
      Given -> @withResources.returns true
      When -> @dir = @subject.findResources {}
      Then -> expect(@dir).to.equal "#{root}/resources"

    context 'no config error', ->
      Given -> @withResources.returns false
      Then -> expect(@subject.findResources()).to.equal ''

  describe '.findServices', ->
    Given -> @path.resolve.withArgs(root, "blah").returns "#{root}/blah"
    Given -> @path.resolve.withArgs(root, "services").returns "#{root}/services"
    Given -> @path.resolve.withArgs(root, "lib").returns "#{root}/lib"
    Given -> @withBlah = @fs.existsSync.withArgs("#{root}/blah")
    Given -> @withServices = @fs.existsSync.withArgs("#{root}/services")
    Given -> @withLib = @fs.existsSync.withArgs("#{root}/lib")

    context 'config dir exists and should beat services and lib', ->
      Given -> @withBlah.returns true
      Given -> @withServices.returns true
      Given -> @withLib.returns true
      When -> @dir = @subject.findServices 'blah'
      Then -> expect(@dir).to.equal "#{root}/blah"

    context 'services exists and should beat lib', ->
      Given -> @withBlah.returns false
      Given -> @withServices.returns true
      Given -> @withLib.returns true
      When -> @dir = @subject.findServices 'blah'
      Then -> expect(@dir).to.equal "#{root}/services"

    context 'lib exists', ->
      Given -> @withBlah.returns false
      Given -> @withServices.returns false
      Given -> @withLib.returns true
      When -> @dir = @subject.findServices 'blah'
      Then -> expect(@dir).to.equal "#{root}/lib"

    context 'none exists', ->
      Given -> @withBlah.returns false
      Given -> @withServices.returns false
      Given -> @withLib.returns false
      Then -> expect(@subject.findServices).with('blah').to.throw new Error "DistillException: Unable to locate services in 'services' or 'lib' and 'blah' from config did not exist."

    context 'no config', ->
      Given -> @withServices.returns true
      Given -> @withLib.returns true
      When -> @dir = @subject.findServices {}
      Then -> expect(@dir).to.equal "#{root}/services"

    context 'no config error', ->
      Given -> @withServices.returns false
      Given -> @withLib.returns false
      Then -> expect(@subject.findServices).to.throw new Error "DistillException: Unable to locate services in 'services' or 'lib' and no directory was passed in config."
