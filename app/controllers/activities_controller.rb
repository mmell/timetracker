require 'activity_time'

class ActivitiesController < ApplicationController
  include ActivityTime

  before_filter :require_user

  # GET /activities
  # GET /activities.xml
  def index
    @activities = get_user.activities.where( "stopped > '#{Time.now.utc - 12.hours}'").order("stopped DESC").all
    @minutes_today = @activities.inject(0) { |memo, e| memo + e.minutes }
    @minutes_today += get_user.current_activity.minutes if get_user.current_activity

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
    end
  end

  def all
    @activities = get_user.activities.where( "stopped > '#{(Time.now() - 31.days).strftime("%Y-%m-%d")}'").order("stopped DESC").all

    respond_to do |format|
      format.html # all.html.erb
      format.xml  { render :xml => @activities }
    end
  end

  # GET /activities/1
  # GET /activities/1.xml
  def show
    @activity = get_user.activities.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/new
  # GET /activities/new.xml
  def new
    @activity = get_user.activities.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = get_user.activities.find(params[:id])
  end

  # POST /activities
  # POST /activities.xml
  def create
    @activity = get_user.activities.new(permit_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to(edit_activity_path(@activity), :notice => 'Activity was successfully created.') }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.xml
  def update
    @activity = get_user.activities.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(permit_params)
        format.html { redirect_to( @activity.project, :notice => 'Activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity = get_user.activities.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(activities_url()) }
      format.xml  { head :ok }
    end
  end

  def start
    @activity = get_user.activities.find(params[:id])
    @current_activity = CurrentActivity.new(
      :started => now,
      :person_id => get_user.id,
      :project_id => @activity.project_id,
      :description => @activity.description
    )

    respond_to do |format|
      if @current_activity.save
        format.html { redirect_to(edit_current_activity_path(@current_activity), :notice => "Successfully started activity for #{@activity.project.name}.") }
        format.xml  { render :xml => @current_activity, :status => :created, :location => @current_activity }
      else
        format.html { redirect_to(@current_activity, :notice => @current_activity.errors) }
        format.xml  { render :xml => @current_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def permit_params
    params.require(:activity).permit(Activity::ParamAttributes)
  end

end
