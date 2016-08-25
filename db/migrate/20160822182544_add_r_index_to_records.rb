class AddRIndexToRecords < ActiveRecord::Migration[5.0]
  def change
    add_index :records, :r
  end
end
