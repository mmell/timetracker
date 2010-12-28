class CurrentActivitiesController < ApplicationController

  before_filter :require_user
  
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
    @current_activity = CurrentActivity.find(params[:id])

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
    @current_activity = CurrentActivity.find(params[:id])
    if @current_activity.description.blank? and !@current_activity.task.activities.empty?
      @current_activity.description = @current_activity.task.activities.last.description
    end
  end

  # POST /current_activities
  # POST /current_activities.xml
  def create
    @current_activity = CurrentActivity.new(params[:current_activity])

    respond_to do |format|
      if @current_activity.save
        format.html { redirect_to(@current_activity, :notice => 'Current activity was successfully created.') }
        format.xml  { render :xml => @current_activity, :status => :created, :location => @current_activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @current_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /current_activities/1
  # PUT /current_activities/1.xml
  def update
    @current_activity = CurrentActivity.find(params[:id])

    respond_to do |format|
      if @current_activity.update_attributes(params[:current_activity])
        format.html { redirect_to( person_activities_path(get_user), :notice => 'Current activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @current_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def adjust_start
    @current_activity = CurrentActivity.find(params[:id])
    @current_activity.update_attributes(:started => (@current_activity.started + params[:adjustment].to_i.minutes) )

    respond_to do |format|
      format.html { redirect_to(edit_current_activity_url(@current_activity)) }
      format.xml  { head :ok }
    end
  end

  def restart
    @current_activity = CurrentActivity.find(params[:id])
    @current_activity.update_attributes(:started => Time.now.utc )

    respond_to do |format|
      format.html { redirect_to(person_activities_url(get_user)) }
      format.xml  { head :ok }
    end
  end

  def cancel
    @current_activity = CurrentActivity.find(params[:id])
    @current_activity.delete # not destroy so the callbacks aren't run

    respond_to do |format|
      format.html { redirect_to(person_activities_url(get_user)) }
      format.xml  { head :ok }
    end
  end

  # DELETE /current_activities/1
  # DELETE /current_activities/1.xml
  def destroy
    @current_activity = CurrentActivity.find(params[:id])
    @current_activity.destroy

    respond_to do |format|
      format.html { redirect_to(person_activities_url(get_user)) }
      format.xml  { head :ok }
    end
  end

end
