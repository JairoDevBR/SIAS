class User < ApplicationRecord
  has_many :schedules
  has_many :emergencies
  has_many :stocks

  OCCUPATION_OPTIONS = [
    ["Bombeiro", 0],
    ["Enfermeiro", 1],
    ["Médico", 2],
    ["Motorista", 3]
   ].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
