class AddColumnsToPatient < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :gender, :string
    add_column :patients, :age, :integer
    add_column :patients, :gravity, :integer
  end
end
