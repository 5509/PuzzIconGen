class PIG.Model.Frame extends Backbone.Model

  _DIR       : 'images/'
  _PREFIX    : 'pazu_frame_'
  _EXTENSION : '.png'

  defaults: {
    path    : null
    imgPath : null
  }

  initialize: ->
    @set({
      imgPath: "#{@_DIR}#{@_PREFIX}#{@get('path')}#{@_EXTENSION}"
    })