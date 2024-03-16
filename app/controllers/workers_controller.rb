class WorkersController < ApplicationController
  before_action :authenticate_user!

  def index
    @workers = Worker.all
    authorize @workers
  end

  def show
    @worker = Worker.find(params[:id])
    authorize @worker
  end

  def update
    @worker = Worker.find(params[:id])
    authorize @worker

    if @worker.update(worker_params)
      redirect_to workers_path, notice: 'Worker was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @worker = Worker.find(params[:id])
    authorize @worker
    @worker.destroy
    redirect_to workers_path, notice: 'Worker was successfully deleted.'
  end

  def new
    @worker = Worker.new
    authorize @worker
  end

  def create

    @worker = Worker.new(worker_params)
    authorize @worker

    if @worker.save
      redirect_to home_adm_path, notice: 'Worker was successfully created.'
    else
      render :new
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :occupation)
  end
end
