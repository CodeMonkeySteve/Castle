require 'spec_helper'

describe Track do
  before(:all) do
    @attrs = Factory.attributes_for(:track).with_indifferent_access
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
      track.should be_new_record
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
      track.should be_new_record
    end
  end
end
