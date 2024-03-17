class AddEmergencyToChat < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :emergency, foreign_key: true
  end
end
