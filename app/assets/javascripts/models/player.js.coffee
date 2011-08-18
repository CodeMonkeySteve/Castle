class @Player
  constructor: (url, pollTime = 1) ->
    @url = url
    @status = @pos = @track = @volume = null
    @loaded = @playing = @paused = @stopped = false
    @playlist = []
    @pollTime = pollTime * 1000.0
    @pollTimer = null

  play:          -> @_refresh(action: 'play')
  pause:         -> @_refresh(action: 'pause')
  stop:          -> @_refresh(action: 'stop')
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
      @loaded = @playing = @paused = @stopped = false
      switch @status
        when 'stopped' then @stopped = true
        when 'loaded'  then @loaded = true
        when 'playing' then @loaded = @playing = true
        when 'paused'  then @loaded = @paused  = true
      @trigger('change:status', @status)

    for key in ['track', 'pos', 'volume', 'playlist']
      if resp[key]? && !_.isEqual(resp[key], @[key])
        @[key] = resp[key]
        delete resp[key]
        @trigger("change:#{key}", @[key])

    #@[key] = resp[val]  for key in []
    true

_.extend(@Player.prototype, Backbone.Events)
