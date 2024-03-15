class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.integer :tesoura
      t.integer :luvas
      t.integer :pinça
      t.integer :esparadrapo
      t.integer :alcool
      t.integer :gaze_esterilizada
      t.integer :atadura
      t.integer :bandagens
      t.integer :medicamentos_basicos
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
