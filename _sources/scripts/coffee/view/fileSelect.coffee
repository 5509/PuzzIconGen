class PIG.View.FileSelect extends Backbone.View
  className: 'mod-fileSelect'

  events: {
    'change input[type="file"]'    : '_onChangeFile'
    'click input[type="checkbox"]' : '_onClickCheckbox'
    'drop'                         : '_onDrop'
    'dragenter'                    : '_onDragEnter'
    'dragover'                     : '_onDragOver'
    'click input[type="radio"]'    : '_onClickRadio'
    'keyup input[data-pig-text]'   : '_onChangePIGRadio'
    'change input[data-pig-text]'  : '_onChangePIGRadio'
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
    @$el.html(@temp)
    # input
    @$lv = @$el.find('[name="lv-text"]').hide()
    @$plus = @$el.find('[name="plus-text"]').hide()

  _onChangeFile: (ev) ->
    $file = $(ev.target).closest('input')
    file = $file.get(0).files[0]
    PIG.events.trigger('select:file', file)

  _onClickCheckbox: (ev) ->
    $checkbox = $(ev.target).closest('input')
    PIG.events.trigger('set:fitScale', $checkbox.is(':checked'))

  _onClickRadio: (ev) ->
    $radio = $(ev.target).closest('input')
    label = $radio.data('pig-radio') or null

    if ( label is 'lv' )
      @$plus.hide()
      @$lv.show()
    else if ( label is 'plus' )
      @$lv.hide()
      @$plus.show()
    else
      @$lv.hide()
      @$plus.hide()

    PIG.events.trigger('set:mode', label)

  _onChangePIGRadio: (ev) ->
    $input = $(ev.target).closest('input')
    mode = $input.data('pig-text')
    value = parseInt($input.val())

    if ( mode is 'lv' )
      if ( 99 < value )
        $input.val(99)
      else if ( value <= 0 )
        $input.val(1)
    else if ( mode is 'plus' )
      if ( 297 < value )
        $input.val(297)
      else if ( value <= 0 )
        $input.val(1)

    PIG.events.trigger('set:modeValue', value)

  temp: """
<div class=\"mod-dropArea\">
  <p><input type=\"file\"></p>
  <p><label><input type=\"checkbox\"> 画像を枠にフィットさせる</label><p>
  <div>
    <ul>
      <li><label><input type="radio" name="radio" data-pig-radio="" checked> 何も付けない</label></li>
      <li><label><input type="radio" name="radio" data-pig-radio="lv"> Lv.を表示する</label></li>
      <li><label><input type="radio" name="radio" data-pig-radio="plus"> +値を表示する</label></li>
    </ul>
    <input type="number" name="lv-text" data-pig-text="lv" min="1" max="99" value="99">
    <input type="number" name="plus-text" data-pig-text="plus" min="1" max="297" value="297">
  </div>
</div>
"""