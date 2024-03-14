class Worker < ApplicationRecord
  has_many :first_schedules, class_name: 'Schedule', foreign_key: 'worker1_id'
  has_many :second_schedules, class_name: 'Schedule', foreign_key: 'worker2_id'

  validates :name, presence: true
  validates :occupation, presence: true
end
