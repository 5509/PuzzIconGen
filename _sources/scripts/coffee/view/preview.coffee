class PIG.View.Preview extends Backbone.View

  tagName: 'div'
  className: 'mod-preview'

  CANVAS_SIZE: 98
  ICON_SIZE: 98
  CANVAS_HAS_TEXT_SIZE: 104
  CANVAS_HASNT_TEXT_SIZE: 98
  CANVAS_WIDTH: 104
  CANVAS_HEIGHT: 104

  initialize: ->

    @dragStart = false

    @model = new PIG.Model.Preview()

    @render()
    @_initReader()
    @_initCanvas()
    @_eventify()

    #@hide()

  events: do ->
    # モバイル振り分け
    if ( PIG.isMobile() )
      events = {
        'touchstart canvas' : '_onDragStart'
        'touchmove  canvas' : '_onDragMove'
        'touchend   canvas' : '_onDragEnd'
      }
    else
      events = {
        'mousedown  canvas' : '_onDragStart'
        'mousemove  canvas' : '_onDragMove'
        'mouseup    canvas' : '_onDragEnd'
      }

    return _.extend(events, {
      'change input[type="range"]'   : '_onChangeRange'
    })

  _eventify: ->
    @listenTo(@model, 'change:isFitScale', =>
      # サイズ調整バーの表示非表示
      isFitScale = @model.get('isFitScale')
      if ( isFitScale )
        @_hideScaleBar()
      else
        @_showScaleBar()

      try
        @_drawIcon()
      catch e
    )
    @listenTo(@model, 'change:iconPos', =>
      @_drawIcon()
    )
    @listenTo(@model, 'change:scale', =>
      @_drawIcon()
    )
    @listenTo(@model, 'change:iconSrc', (model, iconSrc) =>
      @_loadImage(iconSrc, 'icon')
    )
    @listenTo(@model, 'change:frameSrc', (model, frameSrc) =>
      @_loadImage(frameSrc, 'frame')
    )
    @listenTo(@model, 'set:image', =>
      @_drawIcon()
    )
    @listenTo(@model, 'change:mode', =>
      @_drawIcon()
    )
    @listenTo(@model, 'change:modeValue-lv', =>
      @_drawIcon()
    )
    @listenTo(@model, 'change:modeValue-plus', =>
      @_drawIcon()
    )

  _initReader: ->
    @reader = new FileReader()
    @reader.addEventListener('load', =>
      @_onLoadReader()
    , false)

  _onLoadReader: ->
    @model.set('iconSrc', @reader.result)

  _getClientPos: (ev) ->
    # originalEventに元のeventが入っている
    ev = ev.originalEvent
    touches = ev.touches
    # タッチイベントの場合
    if ( touches )
      return {
        x: touches[0].clientX
        y: touches[0].clientY
      }
    # 通常のイベントの場合
    else
      return {
        x: ev.clientX
        y: ev.clientY
      }

  _onDragStart: (ev) ->

    # isFitScaleがオンのときはドラッグできない
    if ( @model.get('isFitScale') )
      return

    ev.preventDefault()

    @dragStart = true
    @dragStartPos = {
      x: 0
      y: 0
    }
    @dragStartEv = @_getClientPos(ev)

  _onDragMove: (ev) ->
    ev.preventDefault()

    if ( not @dragStart )
      return

    dragEndPos = @_getClientPos(ev)
    dragDiff = {
      x: dragEndPos.x - @dragStartEv.x
      y: dragEndPos.y - @dragStartEv.y
    }
    iconPos = @model.get('iconPos')

    @model.set('iconPos', {
      x: iconPos.x + dragDiff.x
      y: iconPos.y + dragDiff.y
    })

    @dragStartEv = dragEndPos

  _onDragEnd: (ev) ->
    ev.preventDefault()

    if ( not @dragStart )
      return

    @dragStart = false

  _onChangeRange: (ev) ->
    $range = $(ev.target).closest('input')

    min = $range.prop('min') or 0
    max = $range.prop('max') or 100
    def = max / 2
    val = $range.val()

    # 5 = 1
    #
    # ** increase
    # 5 5.1 5.2 ... 9.8 9.9 10
    # 1 1.2 1.3 ... 5.8 5.9 6
    #
    # ** decrease
    # 4.9 4.8 ... 0.2 0.1 0
    # (5 - x) * 0.02
    # 0.98 0.96 ... 0.04 0.02 0
    scale = if 5 <= val then val - (def - 1) else 1 - ((5 - val) * (1 / def))
    PIG.events.trigger('set:scale', scale || 0.02)

  _drawIcon: ->
    ctx = @ctx
    canvas = @canvas
    iconPos = @model.get('iconPos')
    scale = @model.get('scale') || 1
    icon = @model.get('iconBaseImage')
    width = @model.get('iconBaseWidth')
    height = @model.get('iconBaseHeight')
    frame = @model.get('iconFrameImage')

    if ( not icon || not frame )
      return

    if ( @model.get('mode') )
      canvas_size = @CANVAS_HAS_TEXT_SIZE
    else
      canvas_size = @CANVAS_HASNT_TEXT_SIZE

    ctx.clearRect(0, 0, canvas_size, canvas_size)

    adjust = if 98 < canvas_size then (canvas_size - @ICON_SIZE) / 2 else 0
    console.log(adjust)
    # アイコンのレンダリング
    isLargerThanCanvas = @ICON_SIZE < width or @ICON_SIZE < height
    if ( @model.get('isFitScale') and isLargerThanCanvas )
      # 横と縦、長い方がベースになる
      base = width < height
      if ( base )
        fitWidth = width * @ICON_SIZE / height
        fitHeight = @ICON_SIZE
        fitPosTop = 0
        fitPosLeft = @ICON_SIZE / 2 - fitWidth / 2 + adjust
      else
        fitWidth = @ICON_SIZE
        fitHeight = height * @ICON_SIZE / width
        fitPosTop = @ICON_SIZE / 2 - fitHeight / 2
        fitPosLeft = adjust

      canvas.setAttribute('width', canvas_size)
      canvas.setAttribute('height', canvas_size)
      ctx.drawImage(icon, fitPosLeft, fitPosTop, fitWidth, fitHeight)
    else
      # base scale
      baseWidth = width
      baseHeight = height
      # set scale
      width = width * scale
      height = height * scale
      # diff
      diffWidth = width - baseWidth
      diffHeight = height - baseHeight
      # diffPos
      x = -diffWidth / 2
      y = -diffHeight / 2
      # movedPos
      movedX = iconPos.x + x
      movedY = iconPos.y + y

      icon.setAttribute('width', width)
      icon.setAttribute('height', height)
      canvas.setAttribute('width', canvas_size)
      canvas.setAttribute('height', canvas_size)

      ctx.drawImage(icon, movedX, movedY, width, height)

    if ( adjust isnt 0 )
      ctx.fillStyle = '#ffffff'
      ctx.fillRect(0, 0, (canvas_size - @ICON_SIZE) / 2, @ICON_SIZE)
      ctx.fillRect(canvas_size - (canvas_size - @ICON_SIZE) / 2, 0, (canvas_size - @ICON_SIZE) / 2, @ICON_SIZE)
      ctx.fillRect(0, @ICON_SIZE, canvas_size, canvas_size - @ICON_SIZE)

    # フレームのレンダリング
    ctx.drawImage(frame, adjust, 0, @ICON_SIZE, @ICON_SIZE)

    @_onRenderText()
    @_createFile()

  _loadImage: (src, target) -> # target: icon or frame
    img = document.createElement('img')

    _onImgLoad = =>
      # アイコンの場合
      if ( target is 'icon')
        @model.set({
          iconBaseWidth  : img.width
          iconBaseHeight : img.height
          iconBaseImage  : img
        })
      # フレームの場合
      else
        @model.set({
          iconFrameImage: img
        })

      @model.trigger('set:image')
      img.removeEventListener('load', _onImgLoad)
      img = null

    img.src = src
    img.addEventListener('load', _onImgLoad, false)

  _initCanvas: ->
    @canvas = document.createElement('canvas')
    @canvas.setAttribute('class', 'mod-canvas-icon')
    @$el.find('.mod-canvas').append(@canvas)
    @ctx = @canvas.getContext('2d')

  _createFile: ->
    dataURL = @canvas.toDataURL(@model.get('type'))
    fileType= @model.get('type').replace('image/', '') or 'png'

    PIG.events.trigger('create:file', {
      href: dataURL
      fileName: "puzzIconGen_#{+(new Date)}_.#{fileType}"
    })

  _onRenderText: ->
    mode = @model.get('mode')
    value = @model.get("modeValue-#{@model.get('mode')}")
    canvas_size = @CANVAS_HAS_TEXT_SIZE
    ctx = @ctx
    ctx.font = "22px KurokaneStd-EB"# NTモトヤバーチ Std W3"
    ctx.textAlign = 'center'
    frontFillStyle = '#f0ff00'
    ctx.shadowColor = '#000000'
    ctx.shadowBlur = 0

    if ( not mode )
      return

    if ( mode is 'lv' )
      if ( value is 99 )
        value = '最大'
      else
        frontFillStyle = '#ffffff'
      value = 'Lv.' + value
    else
      value = '+' + value

    console.log('mode value', mode, value)
    ctx.fillStyle = '#000000'
    ctx.fillText(value, canvas_size/2 - 2, canvas_size + 2 - 4)
    ctx.fillText(value, canvas_size/2 - 2, canvas_size - 2 - 4)
    ctx.fillText(value, canvas_size/2 + 2, canvas_size + 2 - 4)
    ctx.fillText(value, canvas_size/2 + 2, canvas_size - 2 - 4)

    ctx.fillStyle = frontFillStyle
    ctx.shadowBlur = 0
    ctx.fillText(value, canvas_size/2, canvas_size - 4)

  render: ->
    @$el.append(@temp)
    @$scaleBar = @$el.find('.mod-scaleRange')

  setFile: (file) ->
    @model.set('type', file.type)
    @reader.readAsDataURL(file)
    @show()

  setFrame: (frame) ->
    @model.set('frameSrc', frame)

  selectFrame: (frame) ->
    @model.set('frameSrc', frame)

  setFitScale: (isFit) ->
    @model.set('isFitScale', isFit)

  setScale: (scale) ->
    @model.set('scale', scale)

  setMode: (mode) ->
    @model.set('mode', mode)

  setModeValue: (value) ->
    @model.set("modeValue-#{@model.get('mode')}", value)

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()

  _showScaleBar: ->
    @$scaleBar.show()

  _hideScaleBar: ->
    @$scaleBar.hide()

  temp: """
<div class=\"mod-canvas\"></div>
<p class="mod-scaleRange"><input type=\"range\" min="0" max="10" step="0.1">アップロードした画像のサイズを調整できます。</p>
"""