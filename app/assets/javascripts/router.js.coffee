class App.Router extends Backbone.Router
  routes:
    '':       'player'
    'player': 'player'
    'upload': 'upload'

  player: ->
    @_useView( new App.Views.Player() )

  upload: ->
    @_useView( new App.Views.Upload() )

  _useView: (view) ->
    $('body').html( view.el )
    view.render()
