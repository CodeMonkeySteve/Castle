class App.Controller extends Backbone.Controller
  routes:
    '':       'player'
    'player': 'player'

  player: ->
    @_useView( new App.Views.Player() )

  _useView: (view) ->
    $('body').html( view.el )
    view.render()
