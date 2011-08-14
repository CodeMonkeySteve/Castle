require 'authentication'

class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery
  before_filter :authenticate_user!

  rescue_from CouchRest::Model::DocumentNotFound do
    render(:file => 'public/404.html', :status => :not_found, :layout => false)
  end
end
