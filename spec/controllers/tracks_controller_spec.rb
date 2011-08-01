require 'spec_helper'

describe TracksController do
  around do |ex|
    @attrs = Factory.attributes_for(:track)
    with_mp3_file(@attrs) do |path|
      @path = path
      ex.call
    end
  end

  it "#create" do
    post :create, :file => fixture_file_upload(@path, 'audio/mpeg', true)
    response.should be_success
    track = CouchPotato.database.load_document assigns(:track).id
    track.should be_a(Track)
    track.should_not be_new_record
    track.tags.should be_nil
  end

  it "#create (with tags)" do
    post :create, :file => fixture_file_upload(@path, 'audio/mpeg', true), :tags => 'foo, bar, baaz'
    response.should be_success
    track = CouchPotato.database.load_document assigns(:track).id
    track.should be_a(Track)
    track.should_not be_new_record
    track.tags.should == %w(foo bar baaz) 
  end
end