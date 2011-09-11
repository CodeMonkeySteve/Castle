class App.Router extends Backbone.Router
  routes:
    '':       'player'
    'player': 'player'
    'upload': 'upload'

  initialize: ->
    @views = []

  player: ->
    @useViews( new App.Views.Player(), new App.Views.Playlist() )

  upload: ->
    @useViews( new App.Views.Upload() )

  useViews: (views...) ->
    view.unrender?()  for view in @views
    @views = views
    body = $('body').empty()
    for view in @views
      body.append(view.el)
      view.render()
