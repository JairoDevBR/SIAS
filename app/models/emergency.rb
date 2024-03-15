class Emergency < ApplicationRecord
  belongs_to :user
  belongs_to :schedule, optional: true
  has_many :patients

  validates :n_people, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 80, message: "A descrição deve ter no mínimo 80 caracteres" }
end
