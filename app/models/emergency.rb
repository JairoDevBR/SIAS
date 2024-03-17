class Emergency < ApplicationRecord
  after_create :create_chat_channel_stream
  belongs_to :user
  belongs_to :schedule, optional: true
  belongs_to :hospital, optional: true
  has_many :patients

  validates :n_people, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 80, message: "A descrição deve ter no mínimo 80 caracteres" }

  def create_chat_channel_stream
    ActionCable.server.broadcast(
      "chat_channel",
      { command: "create_stream", emergency_id: self.id }
    )
  end
end
