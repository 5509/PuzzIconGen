# Puzzle and Dragons Icon Generator
window.PIG = {}
PIG.Controller = {}
PIG.Model = {}
PIG.Collection = {}
PIG.View = {}

# Handle events
PIG.events = {};
_.extend(PIG.events, Backbone.Events)

PIG.isMobile = ->
  ua = navigator.userAgent
  if ( /iPhone|iPad|Android/.test(ua) )
    return true
  return false