class Track
  include CouchPotato::Persistence

  property :title
  property :artist
  property :album
  property :date
  property :tracknum, type: Fixnum
  property :length,   type: Float
  property :bitrate,  type: Float

  property :created_at
  property :updated_at

  property :tags,  type: Array

  validates_presence_of :title, :artist
  validates_numericality_of :tracknum, only_integer: true, greater_than: 0

  view :by_artist_and_album_and_title, key: [:artist, :album, :title]
#   view :by_tag, type: :raw,
#     map: "function(doc) {
#       if ( doc.tags ) {
#         tags = docs.tags
#         for ( id in tags ) {
#           for ( tag in tags[id] ) {
#             val = tags[id][tag]
#             emit(tag, {sum: val, count: 1, avg: val})
#           }
#         }
#       }
#     }",
#     reduce: "function(keys, values) {
#       res = {sum: 0, count: 0}
#       for ( idx in values ) {
#         val = values[idx]
#         res.sum += val.sum
#         res.count += val.count
#       }
#       res.avg = res.sum / res.count
#       return(res)
#     }"

  def self.from_file( path, content_type = nil, filename = nil )
    info = AudioInfo.new(path.to_s, content_type)
    filename ||= File.basename(path)
    tag = info.to_h

    title, artist, album = tag.values_at(*%w(title artist album)).map { |v| v.try(:strip) }
    track = CouchPotato.database.first self.by_artist_and_album_and_title( key: [artist, album, title] )

    unless track
      track = Track.new
      track.attributes = tag
      track._attachments['body'] = { 'name' => filename, 'content_type' => info.content_type, 'data' => File.read(path) }
    end
    track
  end
end
