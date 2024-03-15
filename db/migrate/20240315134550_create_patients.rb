class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.integer :heart_rate
      t.integer :blood_pressure
      t.integer :respiratory_rate
      t.integer :oxygen_saturation
      t.integer :consciousness
      t.integer :pain
      t.text :medical_history
      t.text :description
      t.references :emergency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
