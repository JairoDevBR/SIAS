class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "emergency_#{params[:emergency_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
