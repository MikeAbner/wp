class ActivitiesController < ApplicationController
  
  before_filter :authorize_user, :except => :show
  before_filter :parse_with_field_to_json, :only => :create
  
  def index
    @activities_selected = 'action-selected'
    @activities = Activity.for( session['user_id'] )
    @activity = Activity.new
  end
  
  def show
    @activity = Activity.find( params[:id] )
  end
  
  def more
    offset = params[:offset].to_i
    @activities = Activity.for( session['user_id'], offset )
    render :layout => nil
  end
  
  def create
    @activity = Activity.new( params[:activity] )
    @activity.owner_id = session['user_id']
    
    if @activity.save
      if @activity.fb_post?
        id = FacebookService.post_activity_to_wall( @current_user, @activity )
        @activity.fb_post_id = id
        @activity.save
      end
      @style = 'display: none;'
      render :partial => 'activity', :locals => { :activity => @activity }
    else
      render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
    end
  end
  
  def destroy
    @activity = Activity.find( params[:id] )

    if @activity.owner_id == session['user_id']
      if @activity.destroy
        render :json => { :status => :ok }, :status => :ok
      else
        render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
      end
    else
      render :json => { :status => :forbidden }, :status => :forbidden
    end

  end
  
private
  
  def parse_with_field_to_json
    if !( with = params[:activity][:with] ).blank?
      params[:activity][:with] = JSON.parse( with )
    else
      params[:activity][:with] = []
    end
  end
end
