class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    if params[:sort_limit]
      @tasks = Task.all.order(limit: :asc).page(params[:page]).per(5)
    elsif params[:sort_priority]
      @tasks = Task.all.order(priority: :asc).page(params[:page]).per(5)
    else
      @tasks = Task.all.order(created_at: :desc).page(params[:page]).per(5)
    end
    if params[:task].present?
      if params[:task][:title].present? && params[:task][:status].present?
        @tasks = Task.where('title LIKE ?', "%#{params[:task][:title]}%").where(status: params[:task][:status]).page(params[:page]).per(5)
      elsif  params[:task][:title].present?
        @tasks = Task.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(5)
      elsif  params[:task][:status].present?
        @tasks = Task.where(status: params[:task][:status]).page(params[:page]).per(5)
      end
    end
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :limit, :status, :priority)
    end
end
