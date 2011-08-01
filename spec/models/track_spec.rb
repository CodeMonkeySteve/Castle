require 'spec_helper'

describe Track do
  before(:all) do
    @attrs = Factory.attributes_for(:track)
  end

  describe "with an MP3 file" do
    around do |ex|
      with_mp3_file(@attrs) do |path|
        @path = path
        ex.call
      end
    end

    it "#from_file"  do
      track = Track.from_file @path, 'audio/mpeg'
      track.attributes.slice(*@attrs.keys).should == @attrs
      track.bitrate.should be_within(10).of(128)
  #      assert track.new_document?
  #    assert_eql? track, Track.by_artist_and_album_and_name([track.artist, track.album, track.name])
    end
  end

  describe "with an Ogg file" do
    around do |ex|
      with_ogg_file(@attrs) do |path|
        @path = path
        ex.call
      end
    end

    it "#from_file"  do
      track = Track.from_file @path, 'audio/ogg'
      track.attributes.slice(*@attrs.keys).should == @attrs
      track.bitrate.should be_within(10).of(128)
  #      assert ! track.new_document?
  #    assert_eql? track, Track.by_artist_and_album_and_name([track.artist, track.album, track.name])
    end
  end
end
