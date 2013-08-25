class PIG.View.FileSelect extends Backbone.View
  className: 'mod-fileSelect'

  events: {
    'change input[type="file"]'    : '_onChangeFile'
    'click input[type="checkbox"]' : '_onClickCheckbox'
    'drop'                         : '_onDrop'
    'dragenter'                    : '_onDragEnter'
    'dragover'                     : '_onDragOver'
  }

  initialize: ->
    @render()

  _onDrop: (ev) ->
    ev.stopPropagation()
    ev.preventDefault()

    ev = ev.originalEvent
    data = ev?.dataTransfer
    files = data?.files
    file = files?[0]

    if ( not file )
      return

    PIG.events.trigger('select:file', file)

  _onDragEnter: (ev) ->
    ev.preventDefault()

  _onDragOver: (ev) ->
    ev.preventDefault()

  render: ->
    @$el.html(_.template(@temp))

  _onChangeFile: (ev) ->
    $file = $(ev.target).closest('input')
    file = $file.get(0).files[0]
    PIG.events.trigger('select:file', file)

  _onClickCheckbox: (ev) ->
    $checkbox = $(ev.target).closest('input')
    PIG.events.trigger('set:fitScale', $checkbox.is(':checked'))

  temp: """
<div class=\"mod-dropArea\">
  <p><input type=\"file\"></p>
  <p><label><input type=\"checkbox\"> 画像を枠にフィットさせる</label><p>
</div>
"""