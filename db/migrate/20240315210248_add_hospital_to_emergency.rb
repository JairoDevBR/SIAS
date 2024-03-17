class AddHospitalToEmergency < ActiveRecord::Migration[7.1]
  def change
    add_reference :emergencies, :hospital, foreign_key: true
  end
end
