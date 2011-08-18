class App.Views.Player extends App.View
  className: 'player'

  events:
    'click .controls .play':     'play'
    'click .controls .pause':    'pause'
    'click .controls .stop':     'stop'
    'click .controls .vol_down': 'vol_down'
    'click .controls .vol_up':   'vol_up'

  play:  -> if App.player.paused  then App.player.pause()  else App.player.play()
  pause: -> App.player.pause()
  stop:  -> App.player.stop()
  vol_down: (ev) -> App.player.incrVol(-5)
  vol_up:   (ev) -> App.player.incrVol(+5)

  initialize: ->
    _.bindAll(this, 'render', 'updateStatus', 'updatePos', 'updateVol')
    App.player.bind('change:status', @updateStatus)
    App.player.bind('change:track', @render)
    App.player.bind('change:playlist', @render)
    App.player.bind('change:pos', @updatePos)
    App.player.bind('change:volume', @updateVol)

  render: ->
    $(@el).html( $.tmpl('player_main', App.player) )

    @volume = @$('.volume .slider').slider
      orientation: 'vertical', range: 'min', min: 0, max: 100
      slide: (event, ui) => @$('.volume .level').html(ui.value)
      stop:  (event, ui) -> App.player.setVol(ui.value)

    @pos = @$('.pos .progress').progressbar()

    @play_btn  = @$('.controls a.play' ).button( icons: { primary: 'ui-icon-play'  }, text: false )
    @pause_btn = @$('.controls a.pause').button( icons: { primary: 'ui-icon-pause' }, text: false )
    @stop_btn  = @$('.controls a.stop' ).button( icons: { primary: 'ui-icon-stop'  }, text: false )
    @$('.controls a.upload' ).button( icons: { primary: 'ui-icon-plusthick' }, text: false )
    @$('.controls a.vol_down' ).button( icons: { primary: 'ui-icon-volume-off' }, text: false )
    @$('.controls a.vol_up'   ).button( icons: { primary: 'ui-icon-volume-on' }, text: false )
    @updateStatus()
    @updatePos(App.player.pos)
    @updateVol(App.player.volume)
    App.player._refresh()

  unrender: ->
    _stopPoll()
    App.player.stopPoll()

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

    if @posTimer?
      clearInterval(@posTimer)
      @posTimer = null

    if p.playing
      @posTimer = setInterval( =>
        @updatePos(App.player.pos += 1)  if App.player.pos? && App.player.track? && (App.player.pos <= App.player.track.length)
      ,  1000)
    true

  updatePos: (pos) ->
    return unless pos? && (track = App.player.track)?
    fmt = (d) -> parseInt((d / 60) % 60) + ':' + pad0(parseInt(d % 60))
    @pos.progressbar('value', 100.0 * pos / track.length )
    @$('.pos .text').html("#{fmt(pos)} / #{fmt(track.length)}")

  updateVol: (vol) ->
    return unless vol?
    @volume.progressbar('value', vol)
    @$('.volume .text').html(vol)
    if App.player.stopped || !App.player.loaded
      $('.vol_up,.vol_down').button('disable')
    else 
      $('.vol_up'  ).button(if App.player.volume < 100 then 'enable' else 'disable')
      $('.vol_down').button(if App.player.volume >   0 then 'enable' else 'disable')

  _stopPoll: ->
    if @posTimer?
      clearInterval(@posTimer)
      @posTimer = null
