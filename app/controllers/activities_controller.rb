class ActivitiesController < ApplicationController
  def index
    @activities_selected = 'action-selected'
    @activities = Activity.desc( :occurred_on )
    @activity = Activity.new
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
end
