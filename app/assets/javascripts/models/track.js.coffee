class @Track extends App.Model
  url: 'Track'
  defaults:
    type: 'Track'

  userRating: ->
    (tag = App.user.tags().forTrack(@id)) && tag[App.player.mood]
