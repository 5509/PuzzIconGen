class PIG.Controller.Puzz extends PIG.Controller.Base

  FRAMES: [
    { name: '火', attr: 'flame' }
    { name: '水', attr: 'water' }
    { name: '木', attr: 'stone' }
    { name: '光', attr: 'light' }
    { name: '闇', attr: 'dark' }
    { name: '回復', attr: 'sexy' }
  ]

  initialize: ->

    # elements
    @$select = $('.mod-select')

    # objects
    @view = {}

    # initalize icon frames
    @frames = new PIG.Controller.Frames(@FRAMES)

    # initialize appFrame
    @view.appFrame = new PIG.View.AppFrame(@frames.coll)

    # then, render ui views
    @render()
    @_eventify()

  _eventify: ->
    events = PIG.events
    appFrame = @view.appFrame

    @listenTo(events, 'select:file', (file) =>
      appFrame.setFile(file)
    )
    @listenTo(events, 'select:frame', (frame) =>
      appFrame.selectFrame(frame)
    )
    @listenTo(events, 'set:fitScale', (isSet) =>
      appFrame.setFitScale(isSet)
    )
    @listenTo(events, 'set:scale', (scale) =>
      appFrame.setScale(scale)
    )
    @listenTo(events, 'set:frame', (frame) =>
      appFrame.setFrame(frame)
    )
    @listenTo(events, 'create:file', (data) =>
      appFrame.setDownload(data)
    )

  render: ->
    @$select.html(@view.appFrame.$el)