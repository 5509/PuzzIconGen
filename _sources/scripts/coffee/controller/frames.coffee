class PIG.Controller.Frames extends PIG.Controller.Base

  initialize: (frames) ->
    @collection = @coll = {}
    @_makeAttrs(frames)

    _.each(@frameAttrs, (obj, key) =>
      @coll[key] = new PIG.Collection.Frames(obj.paths)
      @coll[key].setName(obj.name)
    )

  _makeAttrs: (frames) ->
    @frameAttrs = {}
    @paths = _.pluck(frames, 'attr')
    @attrs = do ->
      ret = {}
      _.each(frames, (val) ->
        ret[val.attr] = val
      )
      return ret

    _.each(@paths, (attr) =>
      @frameAttrs[attr] = {
        name: @attrs[attr].name
        paths: do =>
          ret = [{path: attr}]
          _.each(@paths, (path) ->
            ret.push({
              path: "#{attr}_#{path}"
            })
          )
          return ret
      }
    )