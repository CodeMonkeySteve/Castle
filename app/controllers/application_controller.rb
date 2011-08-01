class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CouchPotato::NotFound do
    render(:file => 'public/404.html', :status => :not_found, :layout => false)
  end
end
