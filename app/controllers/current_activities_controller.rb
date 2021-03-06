class CurrentActivitiesController < ApplicationController

  before_filter :require_user
  before_filter :find_current_activity, :except => [:new, :create]
  
  # GET /current_activities
  # GET /current_activities.xml
  def index
    @current_activities = CurrentActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @current_activities }
    end
  end

  # GET /current_activities/1
  # GET /current_activities/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @current_activity }
    end
  end

  # GET /current_activities/new
  # GET /current_activities/new.xml
  def new
    @current_activity = CurrentActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @current_activity }
    end
  end

  # GET /current_activities/1/edit
  def edit
  end

  # POST /current_activities
  # POST /current_activities.xml
#  def create
#    @current_activity = CurrentActivity.new(permit_params)
#
#    respond_to do |format|
#      if @current_activity.save
#        format.html { redirect_to(@current_activity, :notice => 'Current activity was successfully created.') }
#        format.xml  { render :xml => @current_activity, :status => :created, :location => @current_activity }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @current_activity.errors, :status => :unprocessable_entity }
#     end
#    end
#  end

  # PUT /current_activities/1
  # PUT /current_activities/1.xml
  def update
    respond_to do |format|
      if @current_activity.update_attributes(permit_params)
        format.html { redirect_to( edit_current_activity_url(@current_activity), :notice => 'Current activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @current_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def adjust_start
    if params[:minutes_earlier] != '0'
      started = @current_activity.started - params[:minutes_earlier].to_i.minutes
    elsif params[:minutes_later] != '0'
      started = @current_activity.started + params[:minutes_later].to_i.minutes
    end
    @current_activity.update_attributes(:started => started )

    respond_to do |format|
      format.html { redirect_to(edit_current_activity_url(@current_activity), :notice => 'Current activity was successfully updated.') }
      format.xml  { head :ok }
    end
  end

  def restart
    @current_activity.update_attributes(:started => Time.now.utc )

    respond_to do |format|
      format.html { redirect_to(edit_current_activity_url(@current_activity), :notice => 'Current activity was successfully restarted.') }
      format.xml  { head :ok }
    end
  end

  def cancel
    @current_activity.delete # not destroy so the callbacks aren't run

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end

  # DELETE /current_activities/1
  # DELETE /current_activities/1.xml
  def destroy
    @current_activity.destroy

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end

  def find_current_activity
    @current_activity = get_user.current_activity
    unless @current_activity
      redirect_to(all_activities_url, :alert => "You don't have a current activity.")
      return false
    end
    @project = @current_activity.project
  end
  
  def permit_params
    params.require(:current_activity).permit(CurrentActivity::ParamAttributes)
  end 
  
end
