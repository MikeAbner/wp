class SessionsController < ApplicationController
  def create
    fbid  = params[:uid]
    at    = params[:access_token]
    user  = UserService.find_or_create_by_facebook_id( fbid, at )
    
    user = JSON.parse( user )
    
    if user['_id']
      session['user_id'] = user['_id']
      render :json => { :status => :ok }, :status => :ok
    else
      session['user_id'] = nil
      render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
    end
  end
  
  #we might need to update the access token during use...
  def update
  end
  
  def destroy
    session['user_id'] = nil
    render :json => { :status => :ok }
  end
end
