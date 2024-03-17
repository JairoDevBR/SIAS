class ChatChannel < ApplicationCable::Channel
  def subscribed
    if params[:id].present? && Emergency.exists?(params[:id])
      stream_from "emergency_#{params[:id]}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
