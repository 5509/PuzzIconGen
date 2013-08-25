class PIG.View.Frames extends Backbone.View
  className: 'mod-frames-wrapper'

  events: {
    'click input': '_onClickRadio'
  }

  initialize: (frames) ->
    @render(frames)

    $frames = @$el.find('.mod-frame')
    $defaultFrame = $frames.first().find('input').prop('checked', 'checked')
    $defaultFramePath = $defaultFrame.val()

    _.defer( ->
      PIG.events.trigger('set:frame', $defaultFramePath)
    )

    #@hide()

  render: (frames) ->
    @$el.html(_.template(@temp, { attrs: frames }))

  hide: ->
    @$el.hide()

  show: ->
    @$el.show()

  _onClickRadio: (ev) ->
    $input = $(ev.target).closest('input')
    PIG.events.trigger('select:frame', $input.val())

  temp: """
<% _.each(attrs, function(coll, key) { %>
<p class=\"mod-alt attr-<%= key %>\"><%= coll.getName() %></p>
<ul class=\"mod-frames\">
  <% coll.each(function(model) { %>
  <li class=\"mod-frame\">
    <label>
      <input type=\"radio\"
        name=\"frame\"
        value=\"<%= model.get('imgPath') %>\"><br>
      <img src=\"<%= model.get('imgPath') %>\" width=\"30\">
    </label>
  </li>
  <% }); %>
</ul>
<% }); %>
"""