class PIG.Model.Frame extends Backbone.Model

  DIR       : 'images/'
  PREFIX    : 'pazu_frame_'
  EXTENSION : '.png'

  defaults: {
    path    : null
    imgPath : null
  }

  initialize: ->
    @set({
      imgPath: "#{@DIR}#{@PREFIX}#{@get('path')}#{@EXTENSION}"
    })