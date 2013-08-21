class PIG.Controller.Frames extends PIG.Controller.Base
  initialize: (attrs) ->
    @collection = @coll = {}
    @_makeAttrs(attrs)

    _.each(@frameAttrs, (obj, key) =>
      @coll[key] = new PIG.Collection.Frames(obj.paths)
      @coll[key].setName(obj.name)
    )

  _makeAttrs: (attrs) ->
    @frameAttrs = {}
    @paths = do ->
      ret = []
      _.each(attrs, (val, key) ->
        ret.push(key)
      )
      return ret

    _.each(@paths, (attr) =>
      @frameAttrs[attr] = {
        name: attrs[attr].name
        paths: do =>
          ret = [{path: attr}]
          _.map(@paths, (path) ->
            ret.push({
              path: "#{attr}_#{path}"
            })
          )
          return ret
      }
    )