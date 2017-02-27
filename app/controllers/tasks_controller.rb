class TasksController < ApplicationController
  # TODO - And we will do some LIKE queries and benchmark which is faster.
  def index
    if params[:user_id]
      render json: Task.author(params[:user_id])
    elsif params[:created_after]
      render json: Task.tasks_after_date(params[:created_after])
    else
      render json: Task.all
    end
  end

  def create
    task = Task.create(task_params)
    return render json: {errors: task.errors.messages}, status: 400 unless task.valid?
    render json: task
  end

  def show
    render json: Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    return render json: {errors: task.errors.messages}, status: 400  unless task.valid?
    render json: {success: true}
  end

  def destroy
    render json: {success: "true"} if Task.find(params[:id]).destroy
  end

  private

  def task_params
    # TODO - Think about what would happen if task key was not created automatically.
    params.require(:task).permit(:name, :description, :end_date_on, :user_id)
  end

  def user_params
    y = %w(author).include?(params[:user_id]) ? params[:user_id].to_sym : nil
    puts "user params" + y
    y
  end

  def date_params
    x = %w(tasks_after_date).include?(params[:created_after]) ? params[:created_after].to_sym : nil
    puts x
    x
  end

  def authored_tasks
    Task.where(user_id: user_id).order('tasks.created_at descs')
  end

end
