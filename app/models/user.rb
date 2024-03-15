class User < ApplicationRecord
  has_many :schedules
  has_many :emergencies
  has_many :stocks
  has_one :hospital

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
