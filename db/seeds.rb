user = User.create! :openid_url => 'http://code.monkey.steve.myopenid.com/'

tracks = Dir[Rails.root+'db/seeds/**/*.*'].map do |path|
  track = Track.from_file(path)
  track.save!
  track.put_attachment(File.basename(path), File.open(path), content_type: track.content_type)

  tag = File.basename(File.dirname(path))
  Tag.create! user: user, target: track, tags: { tag => 1 }
end
