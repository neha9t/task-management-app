class TasksController < ApplicationController

  def index
    return render json: [] unless Task.all.order(id: :desc)

    task = authored?
    # task = task.send(date_params) if date_params
    # puts date_params.inspect
    # puts task.inspect
    render json: task
  end

  # Check good practice, whether to return created record in create/update or {sucess: true}
  def create
    task = Task.create(task_params)
    return render json: {errors: task.errors.messages}, status: 400 unless task.valid?
    render json: {success: true}
  end

  def show
    render json: Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    return render json: {errors: task.errors.messages}  unless task.valid?
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
