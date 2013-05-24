require.config {
  shim : {
    'jquery':{
      exports:'jQuery'
    },
    'lodash':{
      exports:'_'
    }
  },
  paths: {
    'jquery' : 'libs/jquery.min'
    'lodash' : 'libs/lodash.min'
    'kazitori' : 'libs/kazitori'
  }
}
index = null
newController = null
contents = null
require ['jquery', 'lodash', 'kazitori'], ()->
  do(window)->
    window.TECH = {
      'version': 0.2
      'debug': true
      'name': 'TECH LAB4'
      'App': null
    }
  TECH.win = window
  TECH.$win = $(TECH.win)

  class Router extends Kazitori
    beforeAnytime: ["checkModel"]
    routes:
      '/':'index'
      '/<string:id>':'show'

    index:()->
      index.hide()
      contents.hide()
      return

    show:(id)->
      if not contents?
        contents = new TECH.ShowController()
      if @.lastFragment isnt '/'
        contents.hideAndShow(id)
      else
        contents.show(id)
      index.slide()
      return

    checkModel:()->
      if not index.hasModelLoaded()
        index.load()
        @suspend()

  require ['app'], ()->
    $(()->
      index = new TECH.IndexController()
      newController = new TECH.NewController()
      contents = new TECH.ShowController()

      do(TECH)->
        TECH.App = new Router()
        $('.brand').on 'click', (event)->
          event.preventDefault()
          TECH.App.change '/'
      # TECH.App.addEventListener KazitoriEvent.FIRST_REQUEST, TECH.App.loadModel
    )