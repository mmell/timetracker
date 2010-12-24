class TasksController < ApplicationController
  before_filter :require_user, :get_objective

  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = @objective.tasks.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
    @activities = @task.activities
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    params[:task][:objective_id] = params[:objective_id]
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to([@objective, @task], :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to([@objective, @task], :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = @objective.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(@objective) }
      format.xml  { head :ok }
    end
  end

  def start
    @current_activity = CurrentActivity.new(
      :started => Time.now,
      :person_id => get_user.id,
      :task_id => params[:id]
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

  def get_objective
    @objective = Objective.find(params[:objective_id])
  end
  private :get_objective

end
