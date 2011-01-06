class ProjectsController < ApplicationController

  before_filter :get_project, :except => [:index, :new, :create]
  before_filter :get_client, :require_user

  # GET /projects
  # GET /projects.xml
  def index
    @projects = @client.nil? ? Project.all(:order => 'clients.name', :include => :client) : @client.projects

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show   
    respond_to do |format|
      format.html # show.html.erb
      format.csv { self.class.layout nil } # must specify layout because we speced admin.html.erb above
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new(:client_id => params[:client_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def start
    @current_activity = CurrentActivity.new(
      :started => Time.now,
      :person_id => get_user.id,
      :project_id => params[:id]
    )

    respond_to do |format|
      if @current_activity.save
        format.html { redirect_to(edit_current_activity_path(@current_activity), :notice => 'Current activity was successfully created.') }
        format.xml  { render :xml => @current_activity, :status => :created, :location => @current_activity }
      else
        task = Task.find(params[:id])
        format.html { redirect_to([@objective, task], :notice => @current_activity.errors) }
        format.xml  { render :xml => @current_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_client
    @client = Client.find(params[:client_id]) if params[:client_id]
  end
  private :get_client

  def get_project
    @project = Project.find(params[:id])
  end
  private :get_project

end
