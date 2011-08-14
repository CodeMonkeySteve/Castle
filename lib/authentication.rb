module Authentication
  def self.included(controller)
    controller.helper_method :current_user
  end

  def sign_in(user)
    @current_user, session[:user_id] = user, user.try(:id)
  end

  def authenticate_user!
    unless current_user
      session[:return_to] = url_for
      redirect_to login_url
      return false
    end
  end

  def current_user
    return @current_user  if @current_user
    if session[:user_id].present?
      @current_user = begin
        User.find! session[:user_id]
      rescue CouchRest::Model::DocumentNotFound
        session[:user_id] = nil
      end
    end
    @current_user
  end
end

