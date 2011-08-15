module Castle

class Player < MPlayer::Player
  attr_accessor :mood

  def initialize
    super
    on_event(:track_end) << method(:on_track_end)
    update_playlist
    play
  end

  def play(*args)
    super
    self.volume ||= 0
  end

protected
  def update_playlist
    self.playlist += Track.by_tag.key(@mood).to_a.shuffle![0...(10 - playlist.size)]
  end

  def on_track_end( track )
debug "end #{track.inspect}"
    playlist.shift
    update_playlist
    play
  end
end

end