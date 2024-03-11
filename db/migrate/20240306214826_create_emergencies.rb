class CreateEmergencies < ActiveRecord::Migration[7.1]
  def change
    create_table :emergencies do |t|
      t.integer :gravity
      t.datetime :time_start
      t.datetime :time_end
      t.integer :n_people
      t.integer :category
      t.float :start_lon
      t.float :start_lat
      t.float :emergency_lon
      t.float :emergency_lat
      t.float :end_lon
      t.float :end_lat
      t.text :description
      t.string :street
      t.string :neighborhood
      t.string :city
      t.references :user, null: false, foreign_key: true
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
