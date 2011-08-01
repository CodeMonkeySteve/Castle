FactoryGirl.define do
  # these must match the MP3/OGG test fixtures
  factory :track do
    title     "Title"
    artist    "Artist"
    album     "Album"
    date      2011
    tracknum  42
    length    1.0
  end
end
