class ActivitiesController < ApplicationController
  
  before_filter :authorize_user, :except => :show
  before_filter :parse_with_field_to_json, :only => :create
  
  def index
    @activities_selected = 'action-selected'
    @activities = Activity.desc( :occurred_on )
    @activity = Activity.new
  end
  
  def show
    @activity = Activity.find( params[:id] )
  end
  
  def create
    @activity = Activity.new( params[:activity] )
    
    if @activity.save
      @style = 'display: none;'
      render :partial => 'activity', :locals => { :activity => @activity }
    else
      render :json => { :status => :unprocessable_entity }, :status => :unprocessable_entity
    end
  end
  
  def parse_with_field_to_json
    params[:activity][:with] = JSON.parse( params[:activity][:with] )
  end
end
