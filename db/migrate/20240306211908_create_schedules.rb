class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.references :worker1, null: false, foreign_key: { to_table: :workers }
      t.references :worker2, null: false, foreign_key: { to_table: :workers }
      t.references :user, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
