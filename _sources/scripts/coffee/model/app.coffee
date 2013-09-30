class PIG.Model.App extends Backbone.Model
  defaults: {
    ready          : false
    main           : 'flame'
    sub            : 'double'
    type           : 'image/png'
    scale          : 1
    selected       : false
    iconSrc        : 'images/tirol.jpg'
    iconBaseWidth  : null
    iconBaseHeight : null
    iconBaseImage  : null
    iconPos        : {
      x: 0
      y: 0
    }
    frameSrc       : null
    iconFrameImage : null
  }

  initialize: ->
    @eventify()
    @_setFramePath({ silent: true })

  eventify: ->

    @on 'change:main', ->
      @_setFramePath()

    @on 'change:sub', ->
      @_setFramePath()

    @on 'change:file', ->
      @set('type', @get('file').type)

    @on 'change:value', ->
      value = @get('value')
      if ( not value )
        @set('mode', null)

  _setFramePath: (options) ->
    main = @get('main')
    sub = @get('sub')

    if ( main is sub )
      sub = ''
    else if ( sub is 'double' )
      sub = "_#{main}"
    else
      sub = "_#{sub}"

    path = "images/pazu_frame_#{main}#{sub}.png"
    @set('path', path, options)
