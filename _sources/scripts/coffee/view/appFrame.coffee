class PIG.View.AppFrame extends Backbone.View

  tagName: 'div'
  className: 'mod-appFrame'

  events: {

  }

  initialize: (frames) ->
    @child = {}
    @child.fileSelect = new PIG.View.FileSelect()
    @child.frames = new PIG.View.Frames(frames)

    @render()

  render: ->
    @$el.append(
      @child['fileSelect'].$el
      @child['frames'].$el
    )