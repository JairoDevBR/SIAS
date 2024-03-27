class ChatsController < ApplicationController

  def create
    @chat = Chat.new
  end

  def show
    @chat = Chat.find(params[:id])
    @post = Post.new
    authorize @chat
  end
end
