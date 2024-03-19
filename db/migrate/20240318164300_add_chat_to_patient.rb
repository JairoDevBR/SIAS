class AddChatToPatient < ActiveRecord::Migration[7.1]
  def change
    add_reference :patients, :chat, foreign_key: true
  end
end
