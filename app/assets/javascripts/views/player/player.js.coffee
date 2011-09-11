class App.Views.Player extends App.View
  events:
    'click .controls .play':    'play'
    'click .controls .pause':   'pause'
    'click .controls .next':    'next'
    'click .controls .vol_dn':  'vol_dn'
    'click .controls .vol_up':  'vol_up'

  play:  -> if App.player.paused  then App.player.pause()  else App.player.play()
  pause: -> App.player.pause()
  next:  -> App.player.next()
  vol_dn: (ev) -> App.player.incrVol(-5)
  vol_up: (ev) -> App.player.incrVol(+5)

  initialize: ->
    _.bindAll(this, 'render', 'updateStatus', 'updatePos', 'updateVol')
    App.player
      .bind('change:status', @updateStatus)
      .bind('change:pos', @updatePos)
      .bind('change:volume', @updateVol)

  render: ->
    $(@el).html( $.tmpl('player_main', App.player) )

    @pos = @$('.pos .progress').progressbar()
    @play_btn  = @$('.controls a.play' ).button( icons: { primary: 'ui-icon-play'  }, text: false )
    @pause_btn = @$('.controls a.pause').button( icons: { primary: 'ui-icon-pause' }, text: false )

    for c, i of { next: 'seek-end', upload: 'plusthick', vol_dn: 'volume-off', vol_up: 'volume-on' }
      @$(".controls a.#{c}" ).button( icons: { primary: "ui-icon-#{i}"  }, text: false )

    @updateStatus()
    @updatePos(App.player.pos)
    @updateVol(App.player.volume)
    App.player._refresh()

  unrender: ->
    @_stopPoll()
    App.player.stopPoll()

  updateStatus: ->
    p = App.player
    if !p.loaded
      @play_btn.show()
      @pause_btn.hide()
      @$('.next').button('disable')
    else if p.paused
      @play_btn.show()
      @pause_btn.hide()
      @$('.next').button('enable')
      @$('.pos').show()
    else
      @play_btn.hide()
      @pause_btn.show()
      @$('.next').button('enable')
      @$('.pos').show()

    if p.playing || p.paused  then @$('.pos')     .show()  else @$('.pos')     .hide()
    if p.loaded  && p.track   then @$('.track')   .show()  else @$('.track')   .hide()

    if @posTimer?
      clearInterval(@posTimer)
      @posTimer = null

    if p.playing
      @posTimer = setInterval( =>
        @updatePos(App.player.pos += 1)  if App.player.pos? && App.player.track? && (App.player.pos < App.player.track.length)
      ,  1000)
    true

  updatePos: (pos) ->
    return unless pos? && (track = App.player.track)?
    fmt = (d) -> parseInt((d / 60) % 60) + ':' + pad0(parseInt(d % 60))
    @pos.progressbar('value', 100.0 * pos / track.length )
    @$('.pos .text').html("#{fmt(pos)} / #{fmt(track.length)}")

  updateVol: (vol) ->
    return unless vol?
    if !App.player.loaded
      $('.vol_up,.vol_dn').button('disable')
    else 
      $('.vol_up'  ).button(if App.player.volume < 100 then 'enable' else 'disable')
      $('.vol_dn').button(if App.player.volume >   0 then 'enable' else 'disable')

  _stopPoll: ->
    if @posTimer?
      clearInterval(@posTimer)
      @posTimer = null
