class TasksController < ApplicationController
  # TODO: And we will do some LIKE queries and benchmark which is faster.

  resource_description do
    short "APIs for managing Tasks"
    formats [:json]
    error 400, "Bad Request"
    error 404, "Not Found"
    error 500, "Internal Server Error"
    meta :author => { :name => 'Neha', :surname => 'Tandon' }
  end

  def_param_group :task do
    param :task, Hash, action_aware: true, desc: "Task information" do
      param :name, String, :desc => "Name of Task", required: true, allow_nil: false
      param :description, String, desc: "Description of task", required: false
      param :end_date_on, String, desc: "Date saved as String", allow_nil: true
      param :user_id, Numeric, required: true, allow_nil: false
    end
  end

  api!

  def index
    if params[:user_id]
      render json: Task.author(params[:user_id])
    elsif params[:created_after]
      render json: Task.tasks_after_date(params[:created_after])
    elsif params[:search]
      begin
        query = params[:search].strip.remove_special_chars.singularize_spaces
        case query
        when ""
          render json: {error: "No Results Found" }
        when query.include?("%")
          binding.pry
          render json: {error: "Invalid Request" }
        else
          render json: Task.search(params[:search]), content_type: "application/json"
        end
      rescue ActiveRecord::StatementInvalid => e
        render json: { error: "Invalid Search Term"}, status: 422, content_type: "application/json"
      end
    else
      render json: Task.all
    end
  end


  api!
  param_group :task, as: :create

  def create
    task = Task.create(task_params)
    return render json: { errors: task.errors.messages }, status: 400 unless task.valid?
    render json: task
  end

  # api :GET, '/tasks/:id', "Shows a single task"
  # param :id, :numeric
  # formats ['json']
  api!
  def show
    render json: set_task
  end

  api :PUT, "/tasks/:id", "Update a task"
  param_group :task, as: :update

  def update
    set_task.update(task_params)
    return render json: { errors: task.errors.messages }, status: 400 unless task.valid?
    render json: { success: true }
  end

  api!
  def destroy
    render json: { success: true } if set_task.destroy
  end


  def autocomplete
    begin
      query = params[:search].strip.remove_special_chars.split(" ").join(" OR ")
      query += "*"

      render json: Task.search(query)
    rescue ActiveRecord::StatementInvalid => e
      render json: { error: "Invalid Search Term"}, status: 422, content_type: "application/json"
    end
  end

  private

  def set_task
    task = Task.find(params[:id])
  end

  def task_params
    # TODO: Think about what would happen if task key was not created automatically.
    params.require(:task).permit(:name, :description, :end_date_on, :user_id)
  end
end
