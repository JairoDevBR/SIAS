class Patient < ApplicationRecord
  belongs_to :emergency
  GENDERS = [['Male', 'male'], ['Female', 'female'], ['Other', 'other']]
end
