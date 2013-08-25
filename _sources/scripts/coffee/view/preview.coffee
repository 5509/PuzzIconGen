class PIG.View.Preview extends Backbone.View

  tagName: 'div'
  className: 'mod-preview'

  CANVAS_SIZE: 98

  initialize: ->

    @dragStart = false

    @model = new PIG.Model.Preview()

    @render()
    @_initReader()
    @_initCanvas()
    @_eventify()

    @hide()

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
    @listenTo(@model, 'set:image', ->
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

    ctx.clearRect(0, 0, canvas.width, canvas.height)

    # アイコンのレンダリング
    isLargerThanCanvas = @CANVAS_SIZE < width or @CANVAS_SIZE < height
    if ( @model.get('isFitScale') and isLargerThanCanvas )
      # 横と縦、長い方がベースになる
      base = width < height
      if ( base )
        fitWidth = width * @CANVAS_SIZE / height
        fitHeight = @CANVAS_SIZE
        fitPosTop = 0
        fitPosLeft = @CANVAS_SIZE / 2 - fitWidth / 2
      else
        fitWidth = @CANVAS_SIZE
        fitHeight = height * @CANVAS_SIZE / width
        fitPosTop = @CANVAS_SIZE / 2 - fitHeight / 2
        fitPosLeft = 0

      canvas.setAttribute('width', @CANVAS_SIZE)
      canvas.setAttribute('height', @CANVAS_SIZE)
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
      canvas.setAttribute('width', @CANVAS_SIZE)
      canvas.setAttribute('height', @CANVAS_SIZE)

      ctx.drawImage(icon, movedX, movedY, width, height)

    # フレームのレンダリング
    ctx.drawImage(frame, 0, 0, @CANVAS_SIZE, @CANVAS_SIZE)

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