module Castle

class Player < MPlayer::Player
  PlaylistSize = 10

  attr_accessor :mood

  def initialize
    super
    on_event(:track_end) << method(:on_track_end)
    update_playlist
    play
  end

protected
  def update_playlist
    #playlist = CouchPotato.database.view Track.by_tag(@mood)
  end

  def on_track_end( track )
debug "end #{track.inspect}"
    play  unless stopped?
    update_playlist
  end
end

end