class DropOldTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :quotes
    drop_table :symbs
  end
end
