class Emergency < ApplicationRecord
  belongs_to :user
  belongs_to :schedule, optional: true
  belongs_to :hospital, optional: true
  has_many :patients

  validates :n_people, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
end
