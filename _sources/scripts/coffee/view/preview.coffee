class PIG.View.Preview extends Backbone.View

  tagName: 'div'
  className: 'mod-preview'

  CANVAS_SIZE: 98
  ICON_SIZE: 98
  CANVAS_HAS_TEXT_SIZE: 104
  CANVAS_HASNT_TEXT_SIZE: 98

  initialize: (attr) ->

    @dragStart = false

    @model = attr.model
    @$el = $('.frame_area')
    @el = @$el.get(0)

    @_initCanvas()
    @_eventify()

    @_loadImage(@model.get('iconSrc'), 'icon')
    @_loadImage(@model.get('path'), 'frame')

  _eventify: ->

    if ( PIG.isMobile() )
      @$el
        .on('touchstart', 'canvas', (ev) =>
          @_onDragStart(ev)
        )
        .on('touchmove', 'canvas', (ev) =>
          @_onDragMove(ev)
        )
        .on('touchEnd', 'canvas', (ev) =>
          @_onDragEnd(ev)
        )
    else
      @$el
        .on('mousedown', 'canvas', (ev) =>
          @_onDragStart(ev)
        )
        .on('mousemove', 'canvas', (ev) =>
          @_onDragMove(ev)
        )
        .on('mouseup', 'canvas', (ev) =>
          @_onDragEnd(ev)
        )

    @listenTo(@model, 'change:main', =>
      @_drawIcon()
    )

    @listenTo(@model, 'change:sub', =>
      @_drawIcon()
    )

    @listenTo(@model, 'change:iconSrc', =>
      @_prepareIcon()
    )

    @listenTo(@model, 'ready', =>
      #@_loadImage(@model.get('iconSrc'), 'icon')
      @_loadImage(@model.get('path'), 'frame')
    )

    @listenTo(@model, 'change:path', =>
      @_loadImage(@model.get('path'), 'frame')
    )

    @listenTo(@model, 'change:iconPos', =>
      @_drawIcon()
    )

    @listenTo(@model, 'set:image', =>
      @_drawIcon()
    )

    @listenTo(@model, 'change:scale', =>
      @_drawIcon()
    )

    @listenTo(@model, 'change:value', =>
      @_drawIcon()
    )

    @listenTo(@model, 'change:mode', =>
      if ( @model.get('mode') )
        return
      @_drawIcon()
    )

    @listenTo(@model, 'change:ready', =>
      $('.loading').fadeOut(500)
    )

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
    # スケールが1のときはドラッグできない
    if ( @model.get('scale') is 1 )
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
    scale = parseInt($range.val(), 10)
    PIG.events.trigger('set:scale', scale)

  _prepareIcon: ->
    img = new Image()
    file = @model.get('file')

    # iPhoneで撮影した画像で500KBを超えているもの
    # 別途処理する、ついでにOrientationも正しい値にしておく
    if ( 500000 < parseInt(file?.size, 10) )
      new MegaPixImage(file).render(img, { maxWidth: 1280, orientation: @model.get('orientation') });

      (chk = =>
        if ( img.src )
          return @_loadImage(img.src, 'icon')
        setTimeout(chk, 100)
      )()
    else
      @_loadImage(@model.get('iconSrc'), 'icon')

  _drawIcon: ->
    ctx = @ctx
    canvas = @canvas
    iconPos = @model.get('iconPos')
    scale = @model.get('scale') || 1
    icon = @model.get('iconBaseImage')
    width = @model.get('iconBaseWidth')
    height = @model.get('iconBaseHeight')
    frame = @model.get('iconFrameImage')
    fitWidth = undefined
    fitHeight = undefined
    fitPosTop = undefined
    fitPosLeft = undefined
    canvas_size = undefined
    adjust = undefined
    space = undefined
    pos = undefined
    base = undefined
    getFitProp = =>
      if ( @model.get('mode') )
        canvas_size = @CANVAS_HAS_TEXT_SIZE
      else
        canvas_size = @CANVAS_HASNT_TEXT_SIZE
      ctx.clearRect(0, 0, canvas_size, canvas_size)
      adjust = if 98 < canvas_size then (canvas_size - @ICON_SIZE) / 2 else 0
      base = width < height
      if ( base )
        fitWidth = width * @ICON_SIZE / height * scale
        fitHeight = @ICON_SIZE * scale
        fitPosTop = 0
        fitPosLeft = @ICON_SIZE / 2 - fitWidth / 2 + adjust

        space = (@ICON_SIZE - fitWidth) / 2
        pos = space + fitWidth
      else
        fitWidth = @ICON_SIZE * scale
        fitHeight = height * @ICON_SIZE / width * scale
        fitPosTop = @ICON_SIZE / 2 - fitHeight / 2
        fitPosLeft = adjust

        space = (@ICON_SIZE - fitHeight) / 2
        pos = space + fitHeight

    if ( not icon || not frame )
      return

    # アイコンのレンダリング
    if ( @model.get('scale') is 1 )
      # スケールが1になった場合は移動をリセット
      @model.set('iconPos', {
        x: 0,
        y: 0
      }, { silent: true })
      getFitProp()
      canvas.setAttribute('width', canvas_size)
      canvas.setAttribute('height', canvas_size)

      ctx.drawImage(icon, movedX, movedY, fitWidth, fitHeight)
      ctx.drawImage(icon, fitPosLeft, fitPosTop, fitWidth, fitHeight)
      ctx.fillStyle = '#ffffff'

      # 写真周りの白縁
      if ( base )
        ctx.fillRect(0, 0, space, @ICON_SIZE)
        ctx.fillRect(pos, 0, space, @ICON_SIZE)
      else
        ctx.fillRect(0, 0, @ICON_SIZE, space)
        ctx.fillRect(0, pos, @ICON_SIZE, space)
    else
      getFitProp()
      movedX = iconPos.x
      movedY = iconPos.y
      canvas.setAttribute('width', canvas_size)
      canvas.setAttribute('height', canvas_size)

      ctx.drawImage(icon, movedX, movedY, fitWidth, fitHeight)

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
    img = new Image()

    _onImgLoad = =>
      if ( not @model.get('ready') )
        @model.set('ready', true)
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
    @canvas = $('canvas').get(0)
    @ctx = @canvas.getContext('2d')

  _createFile: ->
    dataURL = @canvas.toDataURL(@model.get('type'))
    fileType= @model.get('type').replace('image/', '') or 'png'

    @trigger('create:file', {
      href: dataURL
      fileName: "puzzIconGen_#{+(new Date)}_.#{fileType}"
    })

  _onRenderText: ->
    mode = @model.get('mode')
    value = @model.get("value")
    canvas_size = @CANVAS_HAS_TEXT_SIZE
    ctx = @ctx
    ctx.font = "22px kurokane"
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

    ctx.fillStyle = '#000000'
    # 文字外枠
    ctx.fillText(value, canvas_size/2 - 2, canvas_size + 2 - 4)
    ctx.fillText(value, canvas_size/2 - 2, canvas_size - 2 - 4)
    ctx.fillText(value, canvas_size/2 + 2, canvas_size + 2 - 4)
    ctx.fillText(value, canvas_size/2 + 2, canvas_size - 2 - 4)

    ctx.fillStyle = frontFillStyle
    ctx.shadowBlur = 0
    ctx.fillText(value, canvas_size/2, canvas_size - 4)