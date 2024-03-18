class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "emergency_#{params[:emergency_id]}"
    chat = Chat.find(params[:id])
    stream_for chat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
