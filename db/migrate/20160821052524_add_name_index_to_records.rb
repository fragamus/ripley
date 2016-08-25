class AddNameIndexToRecords < ActiveRecord::Migration[5.0]
  def change
    add_index :records, :name
  end
end
