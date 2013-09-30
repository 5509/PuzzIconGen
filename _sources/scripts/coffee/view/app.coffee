class PIG.View.App extends Backbone.View

  events: {
    'click a[data-pig-frame]'     : '_onClickMainAttr'
    'click a[data-pig-sub-frame]' : '_onClickFrame'
    'change input[type="file"]'   : '_onChangeFile'
    'change input[type="range"]'  : '_onChangeScale'
    'keyup input[type="text"]'  : '_onKeyupText'
  }

  initialize: ->
    @model = new PIG.Model.App()
    @$el = $('.app')
    @el = @$el.get(0)

    @preview = new PIG.View.Preview({
      model: @model
    })

    @$frameArea = @$el.find('.frame_area')
    @$textLv = @$el.find('[data-pig-mode="lv"]')
    @$textPlus = @$el.find('[data-pig-mode="plus"]')

    @_initReader()
    @_eventify()

  _eventify: ->

    @listenTo(@preview, 'create:file', (obj) =>

      if ( not @model.get('selected') )
        return

      @$el.find('a.download').attr({
        href: obj.href
        download: obj.fileName
        target: '_blank'
      }).parent().removeClass('disabled')
    )

  _initReader: ->
    @reader = new FileReader()
    @reader.addEventListener('load', =>
      @_onLoadReader()
    , false)

  _onLoadReader: ->
    @model.set('iconSrc', @reader.result)

  _onClickMainAttr: (ev) ->
    ev.preventDefault()
    $attr = $(ev.target).closest('a')
    attr = $attr.data('pig-frame')
    @_changeFrameSet(attr)

    @model.set('main', attr)

  _changeFrameSet: (frame) ->
    prevMainAttr = @model.get('main')
    @$frameArea
      .removeClass(prevMainAttr)
      .addClass(frame)

  _onClickFrame: (ev) ->
    ev.preventDefault()
    $frame = $(ev.target).closest('a')
    sub = $frame.data('pig-sub-frame')
    prevSub = @model.get('sub')

    $('a[data-pig-sub-frame="' + prevSub + '"]').removeClass('active')
    $frame.addClass('active')

    @model.set('sub', sub)

  _onChangeFile: (ev) ->
    $file = $(ev.target).closest('input')
    file = $file.get(0).files[0]

    # EXIFから正しいOrientationを取得しておく
    EXIF.getData(file, =>
      @model.set('orientation', EXIF.getTag(file, 'Orientation'))
    )

    @model.set('selected', true)
    @model.set('file', file)
    @reader.readAsDataURL(file)

  _onChangeScale: (ev) ->
    $range = $(ev.target).closest('input')
    scale = parseFloat($range.val())

    @model.set('scale', scale)

  _onKeyupText: (ev) ->
    $input = $(ev.target).closest('input')
    mode = $input.data('pig-mode')
    value = parseInt($input.val())
    value = if _.isNumber(value) then value else 1

    if ( mode is 'lv' )
      if ( value )
        @$textPlus.val('')
      if ( value < 1 )
        value = 1
      else if ( 99 < value )
        value = 99
        $input.val(value)
    else
      if ( value )
        @$textLv.val('')
      if ( value < 1 )
        value = 1
      else if ( 297 < value )
        value = 297
        $input.val(value)

    if ( not @$textPlus.val() and not @$textLv.val() )
      @model.set('mode', null)
    else if ( value )
      @model.set('mode', mode)
      @model.set('value', value)