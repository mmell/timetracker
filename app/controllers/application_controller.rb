class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_user
  
  def get_user
    @user ||= Person.find(session[:user_id]) if session[:user_id]
  end
# views use this  #private :get_user
  
  def require_user
    unless get_user
      redirect_to(Person, :alert => "Please sign in.")
      return false
    end
    true
  end 
  private :require_user

end
