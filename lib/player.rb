module Castle

class Player < MPlayer::Player
  PlaylistSize = 5

  attr_accessor :mood

  def initialize(mood = nil)
    super '-cache 100000'  # kludge for ogg files
    @mood = mood
    on_event(:track_end) << method(:on_track_end)
    self.next
  end

  def status()    %w(playing paused loaded).find { |s|  send("#{s}?".to_sym) }.try(:to_sym)  end

  def as_json
    {
      status: status,
      mood: mood,
      track: track && track.as_json,
      pos: pos,
      volume: volume
    }.update( playlist: playlist.map(&:as_json) )
  end

  def play(*args)
    super
    self.volume ||= 0
  end

  def next()
    playlist.shift
    update_playlist
    play
  end

protected
  def update_playlist
    if self.playlist.size < PlaylistSize
      self.playlist += Track.all.by_tag(@mood).shuffle!
      self.playlist.uniq!
      self.playlist.slice!(PlaylistSize..-1)
    end
  end

  def on_track_end(track, pos)
    return unless track && (track.path == playlist.first.url)
debug "end #{track.inspect} @ #{pos}"
    self.next  unless self.track
  end
end

end