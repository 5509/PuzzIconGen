class PIG.View.AppFrame extends Backbone.View

  tagName: 'div'
  className: 'mod-appFrame'

  initialize: (frames) ->

    @preview = new PIG.View.Preview()
    @fileSelect = new PIG.View.FileSelect()
    @frames = new PIG.View.Frames(frames)

    @render()

  render: ->
    @$el.append(
      @fileSelect.$el
      @preview.$el
      @frames.$el
      @$link = $(@tmpLinkInavtive)
    )

  renderLink: (file) ->
    @$link.html(_.template(@tmpLinkActive, file))

  setFile: (file) ->
    @preview.setFile(file)

  selectFrame: (frame) ->
    @preview.selectFrame(frame)

  setFrame: (frame) ->
    @preview.setFrame(frame)

  setFitScale: (isFit) ->
    @preview.setFitScale(isFit)

  setScale: (scale) ->
    @preview.setScale(scale)

  setDownload: (file) ->
    @renderLink(file)

  tmpLinkInavtive: """
<p class=\"mod-download\">
  <a href=\"javascript:void(0)\"
     class=\"mod-download-link\"
  >ダウンロードする</a>
</p>
"""

  tmpLinkActive: """
<a href=\"<%= href %>\"
   download=\"<%= fileName %>\"
   target=\"_blank\"
   class=\"mod-download-link state-active\"
>ダウンロードする</a>
"""