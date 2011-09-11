class @Player
  constructor: (url, pollTime = 1) ->
    @url = url
    @status = @mood = @pos = @track = @volume = null
    @loaded = @playing = @paused = false
    @playlist = new App.Collections.Tracks
    @pollTime = pollTime * 1000.0
    @pollTimer = null

  play:          -> @_refresh(action: 'play')
  pause:         -> @_refresh(action: 'pause')
  next:          -> @_refresh(action: 'next')
  incrVol: (vol) -> @_refresh(action: 'volume', data: {vol: if vol < 0 then vol else "+#{vol}"})

  _refresh: (opts = {}) ->
    url = @url
    if opts.action?
      url += '/' + opts.action
      delete opts.action

    req = _.extend({cache: false, dataType: 'json'}, opts || {})
    req.success = (data, status) =>
      @_parse(data)
      opts.success()  if opts.success?

      @stopPoll()
      @pollTimer = setTimeout( =>
        @_refresh()
      ,  @pollTime)

    jQuery.ajax( url, req )

  stopPoll: ->
    if @pollTimer?
      clearTimeout(@pollTimer)
      @pollTimer = null

  _parse: (resp) ->
    if resp.status != @status
      @status = resp.status
      delete resp.status
      @loaded = @playing = @paused = false
      switch @status
        when 'loaded'  then @loaded = true
        when 'playing' then @loaded = @playing = true
        when 'paused'  then @loaded = @paused  = true
      @trigger('change:status', @status)
      @mood = resp.mood

    for key in ['track', 'pos', 'volume']
      if resp[key]? && !_.isEqual(resp[key], @[key])
        @[key] = resp[key]
        delete resp[key]
        @trigger("change:#{key}", @[key])

    if resp.playlist?
      playlist = resp.playlist
      for t in @playlist.models
        @playlist.remove(t) unless _.detect(playlist, (t2) -> t2._id == t.id )

      for t2, idx in playlist
        if (t = @playlist.get(t2._id))?
          t.set(t2)
        else
          @playlist.add(t2, at: idx)

    true

_.extend(@Player.prototype, Backbone.Events)
