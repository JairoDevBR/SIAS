class StocksController < ApplicationController
  def new
    @stock = Stock.new
    @stock.user = current_user
    authorize @stock
  end

  def create
    @stock = Stock.new(stock_params)
    @stock.user = current_user
    authorize @stock

    if @stock.save!
      redirect_to @stock
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @stock = Stock.find(params[:id])
    authorize @stock
  end

  def edit
    @stock = Stock.find(params[:id])
    authorize @stock
  end

  def update
    @stock = Stock.find(params[:id])
    @stock.update(stock_params)
    authorize @stock
    if @stock.update(stock_params)
      redirect_to stock_path(@stock)
    else
      render :edit, status: unprocessable_entity
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:tesoura, :luvas, :pinça, :esparadrapo, :alcool, :gaze_esterilizada, :atadura, :bandagens, :medicamentos_basicos)
  end
end
