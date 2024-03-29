@App =
  Views: {}
  Collections: {}

  init: ->
    new App.Router()
    App.player = new Player('/player', 10.0)
    App.user.tags -> Backbone.history.start()

$(document).ajaxSend (e, xhr, opts) ->
  token = $("meta[name='csrf-token']").attr('content')
  xhr.setRequestHeader('X-CSRF-Token', token)

@pad0  = (n) -> if n < 10  then '0'+n  else n
@pad00 = (n) ->
  if n < 100  then  n = '0'+n
  if n < 10   then  n = '0'+n
  n
