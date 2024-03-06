class Schedule < ApplicationRecord
  belongs_to :worker
  belongs_to :user
  has_many :emergencies
end
