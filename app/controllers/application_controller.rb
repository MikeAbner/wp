class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :load_user
  
  def load_user
    if session['user_id']
      @current_user = UserService.find( session['user_id'] )
    end
  rescue
    session['user_id'] = nil
  end
  
  def authorize_user
    redirect_to root_path unless @current_user
  end
  
end
