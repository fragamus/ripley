class AddSsnIndexToRecords < ActiveRecord::Migration[5.0]
  def change
    add_index :records, :ssn
  end
end
