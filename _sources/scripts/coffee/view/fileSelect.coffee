class PIG.View.FileSelect extends Backbone.View
  className: 'mod-fileSelect'

  events: {
    'change input': '_onChangeFile'
  }

  initialize: ->
    @render()

  render: ->
    @$el.html(_.template(@temp))

  _onChangeFile: (ev) ->
    $file = $(ev.target).closest('input')
    console.log($file.val())

  temp: """
<div class=\"mod-dropArea\">
  <p>1. 画像ファイルを選択するか、このエリアにドラッグドロップしてください。</p>
  <p>2. 属性フレームが表示されるので、好きな属性を選択してください。</p>
  <p>3. Downloadボタンをクリック（タップ）してください。</p>
  <p><input type=\"file\"></p>
</div>
"""