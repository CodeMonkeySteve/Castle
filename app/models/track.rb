class Track < CouchRest::Model::Base
  property :title
  property :artist
  property :album
  property :date
  property :tracknum, Fixnum
  property :length,   Float
  property :bitrate,  Float

  timestamps!

  validates_presence_of :title, :artist
  validates_numericality_of :tracknum, only_integer: true, greater_than: 0, allow_nil: true

  def url
    self.attachment_url(self.attachments.keys[0])
  end

  design do
    view :by_artist_and_album_and_title, :allow_nil => true
    view :by_tag,
      :map => "function(doc) {
        if (doc['type'] == 'Track' && doc.tags) {
          doc.tags.forEach(function(tag) {  emit(tag, 1)  })
        }
      }",
      :reduce => "function(keys, values, rereduce) {  return sum(values)  }"
  end

  def self.from_file( path, content_type = nil )
    info = AudioInfo.new(path.to_s, content_type)
    tag = info.to_h

    title, artist, album = tag.values_at(*%w(title artist album)).map { |v| v.try(:strip) }
    track = self.find_by_artist_and_album_and_title([artist, album, title])

    track ||= Track.new( tag.reject { |k, v| v.blank? } )
    track
  end
end
