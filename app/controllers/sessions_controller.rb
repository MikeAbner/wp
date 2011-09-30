class SessionsController < ApplicationController
  def create
    fbid  = params[:uid]
    at    = params[:access_token]
    user  = UserService.find_or_create_by_facebook_id( fbid, at )
    user  = JSON.parse( user )
    UserService.login!( user['_id'] )
    
    if user['_id']
      session['user_id'] = user['_id']
      render :json => { :status => :ok }, :status => :ok
    else
      session['user_id'] = nil
      render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
    end
  end

  def fb_create
    auth  = request.env["omniauth.auth"]
    fbid  = auth['uid']
    at    = auth['credentials']['token']
    user  = UserService.find_or_create_by_facebook_id( fbid, at )
    user  = JSON.parse( user )
    UserService.login!( user['_id'] )
    
    if user['_id']
      session['user_id'] = user['_id']
      redirect_to activities_path
    else
      session['user_id'] = nil
      redirect_to root_path
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
