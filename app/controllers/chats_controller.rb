class ChatsController < ApplicationController

  def show
    @chat = Chat.find(params[:id])
    @post = Post.new
    authorize @chat
  end
end
