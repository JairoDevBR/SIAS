class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(1)
    @message = Message.new
    authorize @chatroom
  end
end
