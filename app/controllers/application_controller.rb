class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  def require_admin
    if current_user.admin? == false
      flash[:alert] = "Only Admin can view this page."
      redirect_to new_user_path
    end
  end


  def @current_user.admin?
    @current_user.admin == true
  end

  
  helper_method :current_user
  
end
