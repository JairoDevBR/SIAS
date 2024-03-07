class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :central, :boolean
    add_column :users, :class, :integer
    add_column :users, :plate, :string
  end
end
