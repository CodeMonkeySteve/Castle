require 'spec_helper'

describe UsersController do
  describe 'with a user' do
    before do
      sign_in @user = Factory.create(:user)
    end

    it '#logout' do
      get :logout
      controller.current_user.should be_nil
      session['user_id'].should be_nil
      response.should redirect_to('/')
    end
  end

  describe 'without a user' do
    before do
      @user = Factory.attributes_for(:user)
    end

    it 'renders login page' do
      get :login
      response.should be_success
      response.should render_template('users/login')
    end

    it 'starts openid login' do
      post :login, :openid_identifier => @user[:openid_url]
      response.status.should == 401
      response.headers[Rack::OpenID::AUTHENTICATE_HEADER].should match(@user[:openid_url])
    end

    it 'completes openid login' do
      User.find_by_openid_url(@user[:openid_url]).should be_nil
      resp = stub(request.env['rack.openid.response'] = {})
      resp.status { :success }
      resp.identity_url { @user[:openid_url] }
      stub(OpenID::SReg::Response).from_success_response(anything) { {'nickname' => @user[:name]} }

      get :login
      User.by_openid_url.key(@user[:openid_url]).count.should == 1
    end
  end
end
