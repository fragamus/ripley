class CreateThings < ActiveRecord::Migration[5.0]
  def change
    create_table :things do |t|
      t.string :path
      t.string :h
      t.string :r

      t.timestamps
    end
  end
end
