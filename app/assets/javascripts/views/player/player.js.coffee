class App.Views.Player extends App.View
  className: 'player'

  events:
    'click button.play':  'play'
    'click button.pause': 'pause'
    'click button.stop':  'stop'

  play:  -> if App.player.paused  then App.player.pause()  else App.player.play()
  pause: -> App.player.pause()
  stop:  -> App.player.stop()

  initialize: ->
    _.bindAll(this, 'render', 'updateStatus', 'updatePos', 'updateVol')
    App.player.bind('change:status', @updateStatus)
    App.player.bind('change:track', @render)
    App.player.bind('change:pos', @updatePos)
    App.player.bind('change:volume', @updateVol)

  render: ->
    $(@el).html( $.tmpl('player_main', App.player) )

    @volume = @$('.volume .slider').slider
      orientation: 'vertical', range: 'min', min: 0, max: 100
      slide: (event, ui) => @$('.volume .level').html(ui.value)
      stop:  (event, ui) -> App.player.setVol(ui.value)

    @pos = @$('.pos .progress').progressbar()
    @updateVol(App.player.volume)  if App.player.volume

    @play_btn  = @$('.controls button.play' ).button( icons: { primary: 'ui-icon-play'  }, text: false )
    @pause_btn = @$('.controls button.pause').button( icons: { primary: 'ui-icon-pause' }, text: false )
    @stop_btn  = @$('.controls button.stop' ).button( icons: { primary: 'ui-icon-stop'  }, text: false )
    @updateStatus()
    App.player._refresh()

  updateStatus: ->
    p = App.player
    if p.stopped || !p.loaded
      $('.volume').hide()
      @play_btn.show()
      @pause_btn.hide()
      @stop_btn.button('disable')
    else if p.paused
      @play_btn.show()
      @pause_btn.hide()
      @stop_btn.button('enable')
      @$('.pos').show()
    else
      @play_btn.hide()
      @pause_btn.show()
      @stop_btn.button('enable')
      @$('.pos').show()

    if p.playing || p.paused  then @$('.pos')     .show()  else @$('.pos')     .hide()
    if p.loaded  && p.track   then @$('.track')   .show()  else @$('.track')   .hide()
    if p.playlist.length      then @$('.playlist').show()  else @$('.playlist').hide()
    true

  updatePos: (pos) ->
    return unless (track = App.player.track)?
    fmt = (d) -> parseInt((d / 60) % 60) + ':' + pad0(parseInt(d % 60))
    @pos.progressbar('value', 100.0 * pos / track.length )
    @$('.pos .text').html("#{fmt(pos)} / #{fmt(track.length)}")

  updateVol: (vol) ->
    @volume.slider('value', vol)
    @$('.volume .level').html(vol)
    $('.volume').show()  unless App.player.stopped || !App.player.loaded
