require 'spec_helper'

describe TracksController do
  before do
    sign_in @user = Factory.create(:user)
  end

  it "#create" do
    @attrs = Factory.attributes_for(:track)
    with_mp3_file(@attrs) do |path|
      post :create, :file => fixture_file_upload(path, 'audio/mpeg', true)
    end
    response.should be_success
    track = Track.find! assigns(:track).id
    track.should be_a(Track)
    track.should_not be_new_record
  end
end