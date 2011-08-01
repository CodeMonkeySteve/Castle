root = exports ? this
root.App =
  Views: {}
  Collections: {}

  init: ->
    new App.Controller()
    App.player = new Player('/player', 3.0)
    Backbone.history.start()

@pad0  = (n) -> if n < 10  then '0'+n  else n
@pad00 = (n) ->
  if n < 100  then  n = '0'+n
  if n < 10   then  n = '0'+n
  n
