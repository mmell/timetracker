class ActivitiesController < ApplicationController

  before_filter :require_user
  
  # GET /activities
  # GET /activities.xml
  def index
    @activities = get_user.activities.find(:all, :conditions => "stopped > '#{Time.now.utc - 12.hours}'")
    @minutes_today = @activities.inject(0) { |memo, e| memo + e.minutes }
    @minutes_today += get_user.current_activity.minutes if get_user.current_activity

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
    end
  end

  def all
    @activities = get_user.activities.find(:all, :conditions => ["stopped > '#{(Time.now() - 31.days).strftime("%Y-%m-%d")}'"])

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
    @activity = get_user.activities.new(params[:activity])

    respond_to do |format|
      if @activity.save
        format.html { redirect_to(edit_person_activity_path(get_user, @activity), :notice => 'Activity was successfully created.') }
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
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to( person_activities_path(get_user), :notice => 'Activity was successfully updated.') }
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
      format.html { redirect_to(person_activities_url(get_user)) }
      format.xml  { head :ok }
    end
  end
end
