class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CouchRest::Model::DocumentNotFound do
    render(:file => 'public/404.html', :status => :not_found, :layout => false)
  end
end
