class ChatsController < ApplicationController

  def create
    @chat = Chat.new
  end

  def show
    # @emergency = Emergency.find(params[:emergency_id])
    @chat = Chat.find(params[:id])
    @post = Post.new
    authorize @chat
  end
end
