class PIG.Controller.Puzz extends PIG.Controller.Base
  initialize: ->

    # elements
    @$select = $('.mod-select')

    # objects
    @view = {}

    # initalize icon frames
    @frames = new PIG.Controller.Frames({
      flame : { name: '火' }
      water : { name: '水' }
      stone : { name: '木' }
      light : { name: '光' }
      dark  : { name: '闇' }
      sexy  : { name: '回復' }
    })

    # initialize appFrame
    @view.appFrame = new PIG.View.AppFrame(@frames.coll)

    # then, render ui views
    @render()

  render: ->
    @$select.html(@view.appFrame.$el)