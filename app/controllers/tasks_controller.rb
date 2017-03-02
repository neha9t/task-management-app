class TasksController < ApplicationController
  # to skip protect_from_
  skip_before_action :verify_authenticity_token

  before_action :find_task, only: [:show, :update, :destroy]
  formats [:json]

  # Apipie Related
  resource_description do
    short "APIs for managing Tasks"
    description "APIs for managing Tasks"
    formats [:json]
    error 400, "Bad Request"
    error 404, "Not Found"
    error 500, "Internal Server Error"
    meta :author => { :name => 'Neha', :surname => 'Tandon' }
  end

  def_param_group :task do
    param :name, String,:action_aware => true, :desc => "Name of the task", required: true
    param :description, String,:action_aware => true, desc: "Description of the task", required: true
    param :end_date_on, String, :action_aware => true,desc: "End date for the task", required: false, allow_nil: false
    param :user_id, Integer, :action_aware => true, desc: "Integer id of the user to whom the task belongs", required: true
  end

  api :GET, "/tasks", "Filter tasks"
  param :user_id, Integer, desc: "Id of a user by which tasks would be filtered", required: false
  param :created_after, String, desc: "If supplied, only tasks created after this date would be returned", required: false
  param :search, String, :desc => "A search string which is used to perform full text search.The following operators are supported between words https://github.com/mrkamel/search_cop#supported-operators", required: false
  description "Get a list of tasks (optionally with some filter). Note only one filter parameter out of the following is supported per request."
  formats ['json']

  def index
    if params[:user_id]
      render json: Task.author(params[:user_id])
    elsif params[:created_after]
      render json: Task.tasks_after_date(params[:created_after])
    elsif params[:before_date]
      render json: Task.before_end_date(params[:before_date])
    elsif params[:search]
      begin
        query = params.strip.remove_special_chars.singularize_spaces
        if query == ""
          render json: {error: "No Results Found" }, status: 400
        else
          render json: Task.search(query)
        end
      rescue ActiveRecord::StatementInvalid => e
        render json: { error: "Invalid Search Term"}, status: 400, content_type: "application/json"
      end
    else
      render json: Task.all
    end
  end

  api :POST, "/tasks", "Create new task", desc: "API to create a new task"
  param_group :task, as: :create
  formats ['json']

  def create
    task = Task.create(task_params)
    return render json: { errors: task.errors.messages }, status: 400 unless task.valid?
    render json: task
  end

  api :GET, '/tasks/:id', "Get a single task"
  param :id, Integer, desc: "Id of the task whose details are required"
  formats ['json']

  def show
    render json: @task
  end

  api :PUT, "/tasks/:id", "Update a task"
  param_group :task, as: :update
  formats ['json']


  def update
    @task.update(task_params)
    return render json: { errors: @task.errors.messages }, status: 400 unless @task.valid?
    render json: { success: true }
  end

  api :DELETE, "/tasks/:id", "Delete a task"
  param :id, Integer, :desc => "Id of the task to be deleted"
  formats ['json']

  def destroy
    render json: { success: true } if @task.destroy
  end

  api :GET, "/autocomplete", "Autocomplete API"
  param :search, String, :desc => "Search string for autocompletion"
  formats ['json']

  def autocomplete
    begin
      query = params[:search].strip.remove_special_chars.split(" ").join(" OR ")
      query += "*"
      render json: Task.search(query)
    rescue ActiveRecord::StatementInvalid => e
      render json: { error: "Invalid Search Term"}, status: 400, content_type: "application/json"
    end
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :end_date_on, :user_id)
  end
end
