class App.Views.Playlist extends App.View
  className: 'playlist panel'

  events:
    'click .track .vote_up':    'vote_up'
    'click .track .vote_dn':    'vote_dn'

  vote_up: (ev) ->
    mood = App.player.mood
    id = $(ev.currentTarget).closest('div.track[id]').attr('id')
    rating = (t = App.user.tags().forTrack(id)) && t[mood]
    tag = {}
    tag[mood] = if (rating == 1)  then null  else 1
    App.user.tags().tagTrack( id, tag )

  vote_dn: (ev) ->
    mood = App.player.mood
    id = $(ev.currentTarget).closest('div.track[id]').attr('id')
    rating = (t = App.user.tags().forTrack(id)) && t[mood]
    tag = {}
    tag[mood] = if (rating == 0)  then null  else 0
    App.user.tags().tagTrack( id, tag )

  initialize: ->
    _.bindAll(this, 'render', 'addTrack', 'changeTrack', 'removeTrack')
    App.player.playlist
      .bind('reset', @render)
      .bind('add', @addTrack)
      .bind('remove', @removeTrack)
    true

  render: ->
    $(@el).html( $.tmpl('playlist_main', App.player) )
    model.bind('change', @changeTrack)   for model in App.player.playlist.models
    true

  addTrack: (track) ->
    track.bind('change', @changeTrack)
    $('<li></li>').appendTo('ul.tracks')
      .html( $.tmpl('playlist_track', track) )

  changeTrack: (track) ->
    $("ul.tracks li div.track[id='#{track.id}']")
      .replaceWith( $.tmpl('playlist_track', track) )

  removeTrack: (track) ->
    $("ul.tracks li div.track[id='#{track.id}']")
      .closest('li').remove()
