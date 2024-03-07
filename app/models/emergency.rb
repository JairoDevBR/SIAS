class Emergency < ApplicationRecord
  belongs_to :user
  belongs_to :schedule, optional: true
end
