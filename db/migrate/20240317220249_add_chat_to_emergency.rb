class AddChatToEmergency < ActiveRecord::Migration[7.1]
  def change
    add_reference :emergencies, :chat, foreign_key: true
  end
end
