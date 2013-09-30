class PIG.Controller.App extends PIG.Controller.Base

  initialize: ->
    if ( PIG.isMobile() )
      $('html').addClass('sp')

    webfontText = 'Lv.0123456789最大+ダウンロードお@shimaelrw写真をえらぶ拡待ちください'

    # KurokaneStd-EBサブセットの読み込み
    FONTPLUS.load([
      {
        fontname: 'KurokaneStd-EB'
        # font-family: kurokane で利用できる
        nickname: 'kurokane'
        # 'aAあ': http://pr.fontplus.jp/api/
        text: webfontText + 'aAあ'
      }
    ], =>
      view = new PIG.View.App()
    )