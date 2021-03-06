class PeopleController < ApplicationController
  require 'reports'

  before_filter :get_person, :require_user, :except => [:login, :index, :new, :create]

  def reports
    unless params[:project_id]
      current_day = Date.current.day
      if current_day < 15
        delta = current_day
        @end_date = Date.current() - delta.days # last day of the last month
        @start_date = @end_date - 14.days # the 15th of the previous month # FIXME
      else
        delta = current_day - 15
        @end_date = Date.current() - delta.days # first day of this month
        @start_date = @end_date - 14.days # the 1st of the previous month # FIXME
      end
      @project = (get_user.project.nil? ? get_user.projects.last : get_user.project) # FIXME crashes if user has no activities
      return
    end
    @end_date = Time.parse("#{params[:until][:year]}-#{params[:until][:month]}-#{params[:until][:day]}")
    @start_date = Time.parse("#{params[:from][:year]}-#{params[:from][:month]}-#{params[:from][:day]}")
    @project = Project.find(params[:project_id])

    report = "Reports::#{params[:format]}".constantize.new(@start_date, @end_date, @project, get_user )
    send_data(report.render,
      :filename => report.file_name,
      :disposition => 'attachment', # default
      :type => 'application/octet-stream' # default
    )
  end

  # GET /people
  # GET /people.xml
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  def login
    if params[:id] and @user = Person.find(params[:id])
      session[:user_id] = @user.id
      redirect_to activities_path, :notice => "Welcome #{@user.name}"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :back
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(permit_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully created.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    respond_to do |format|
      if @person.update_attributes(permit_params)
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def project_position
    project = Project.find(params[:project_id])
    redirect_opts = {}
    if project # FIXME: confirm that person has access to project
      @person.shift_project_position(project, params[:move_to])
      redirect_opts[:notice] = "Successfully set the project priority."
    else
      redirect_opts[:alert] = "Project not found."
    end
    redirect_to(:back, redirect_opts)
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  def time_zone
    get_person.update_attributes(time_zone: params[:person][:time_zone])
    redirect_to(:back)
  end

  def permit_params
    params.require(:person).permit(Person::ParamAttributes)
  end

  def get_person
    # @user comes from the session and may be different than the target person.
    # FIXME: enforce security
    @person ||= Person.find(params[:id])
  end
  private :get_person

end
