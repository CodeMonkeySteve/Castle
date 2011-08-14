class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:login, :logout]
  def login
    if resp = request.env['rack.openid.response']
      case resp.status
        when :success
          unless user = User.find_by_openid_url(resp.identity_url)
            reg = OpenID::SReg::Response.from_success_response(resp)
            user = User.create!(openid_url: resp.identity_url, name: reg['nickname'])
          end
          sign_in user
          redirect_to, session[:return_to] = session[:return_to], nil
          redirect_to( redirect_to || root_url )

        when :failure
          flash[:alert] = resp.message
      end

    elsif request.post? && params[:openid_identifier].present?
      response.headers['WWW-Authenticate'] = Rack::OpenID.build_header( identifier: params[:openid_identifier], required: [:nickname] )
      render nothing: true, status: :unauthorized
    end
  end

  def logout
    sign_in nil
    redirect_to root_url
  end
end