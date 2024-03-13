class Schedule < ApplicationRecord
  attr_accessor :worker1_name, :worker2_name

  belongs_to :worker1, class_name: 'Worker'
  belongs_to :worker2, class_name: 'Worker'
  belongs_to :user
  has_many :emergencies
end
