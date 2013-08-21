class PIG.Collection.Frames extends Backbone.Collection
  model: PIG.Model.Frame

  setName: (name) ->
    @name = "#{name}属性"

  getName: ->
    return @name