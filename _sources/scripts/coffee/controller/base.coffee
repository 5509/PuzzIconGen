class PIG.Controller.Base
  constructor: (attr...) ->
    @initialize(attr...)

  initialize: ->

_.extend(PIG.Controller.Base.prototype, Backbone.Events)