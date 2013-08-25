class PIG.Model.Preview extends Backbone.Model
  defaults: {
    type           : 'image/png'
    isFitScale     : false
    scale          : 1
    iconSrc        : null
    iconBaseWidth  : null
    iconBaseHeight : null
    iconBaseImage  : null
    iconPos        : {
      x: 0
      y: 0
    }
    frameSrc       : null
    iconFrameImage : null
  }