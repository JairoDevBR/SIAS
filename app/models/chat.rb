class Chat < ApplicationRecord
  has_many :posts
  has_many :emergencies
end
