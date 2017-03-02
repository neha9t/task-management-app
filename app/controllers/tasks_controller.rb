class TasksController < ApplicationController
  # to skip protect_from_
  skip_before_action :verify_authenticity_token

  before_action :find_task, only: [:show, :update, :destroy]
  before_action :filter_task_by_after_date, only: [:index]
  before_action :filter_by_author, only: [:index]
  before_action :filter_task_before_end_date, only: [:index]
  before_action :search_cop, only: [:index]
  formats [:json]

  # APIPIE Related
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

  # Controller:

  def index
    if params[:user_id]
      render json: @filter_user
    elsif params[:created_after]
      render json: @filter_after
    elsif params[:before_date]
      render json: @filter_before
    elsif params[:search]
      render json: @search_result
    else
      render json: Task.all
    end
  end

  api :POST, "/tasks", "Create new task", desc: "API to create a new task"
  param_group :task, as: :create

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

  def filter_task_by_after_date
    @filter_after= Task.tasks_after_date(params[:created_after])
  end

  def filter_by_author
    @filter_user = Task.author(params[:user_id])
  end

  def filter_task_before_end_date
    @filter_before = Task.before_end_date(params[:before_date])
  end

  def search_cop
    @search_result = full_text_search(params[:search])
  end

  def full_text_search(params)
    begin
      query = params.strip.remove_special_chars.singularize_spaces
      if query == ""
        {error: "No Results Found" }
      else
        Task.search(query) # search_cop method: search
      end
    rescue ActiveRecord::StatementInvalid => e
      render json: { error: "Invalid Search Term"}, status: 400, content_type: "application/json"
    end
  end
end
