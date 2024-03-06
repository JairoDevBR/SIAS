class CreateWorkers < ActiveRecord::Migration[7.1]
  def change
    create_table :workers do |t|
      t.string :name
      t.integer :occupation

      t.timestamps
    end
  end
end
