class ActivitiesController < ApplicationController
  
  before_filter :authorize_user, :except => :show
  before_filter :parse_with_field_to_json, :only => :create
  
  def index
    @activities_selected = 'action-selected'
    @activities = Activity.where(:owner_id => session['user_id'] ).desc( :when, :created_at ).limit( 5 ).all
    @activity = Activity.new
  end
  
  def show
    @activity = Activity.find( params[:id] )
  end
  
  def more
    offset = params[:offset].to_i
    @activities = Activity.where(:owner_id => session['user_id'] ).desc( :when, :created_at ).offset( offset ).limit( 5 ).all
    render :layout => nil
  end
  
  def create
    @activity = Activity.new( params[:activity] )
    @activity.owner_id = session['user_id']
    
    if @activity.save
      @style = 'display: none;'
      render :partial => 'activity', :locals => { :activity => @activity }
    else
      render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
    end
  end
  
  def destroy
    @activity = Activity.find( params[:id] )
    if @activity.destroy
      render :json => { :status => :ok }, :status => :ok
    else
      render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
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
