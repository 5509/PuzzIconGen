class PIG.View.Frames extends Backbone.View

  events: {
    'click input': '_onClickRadio'
  }

  initialize: (frames) ->
    @render(frames)
    #@hide()

  render: (frames) ->
    @$el.html(_.template(@temp, { attrs: frames }))

  hide: ->
    @$el.hide()

  show: ->
    @$el.show()

  _onClickRadio: (ev) ->
    $input = $(ev.target).closest('input')
    console.log($input.attr('value'))

  temp: """
<% _.each(attrs, function(coll, key) { %>
<p class=\"mod-alt\"><%= coll.getName() %></p>
<ul class=\"mod-frames\">
  <% coll.each(function(model) { %>
  <li class=\"mod-frame\">
    <label>
      <input type=\"radio\"
        name=\"frame\"
        value=\"<%= model.get('imgPath') %>\"><br>
      <img src=\"<%= model.get('imgPath') %>\" width=\"35\">
    </label>
  </li>
  <% }); %>
</ul>
<% }); %>
"""