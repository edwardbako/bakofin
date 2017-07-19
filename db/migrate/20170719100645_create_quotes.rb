class CreateQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :quotes do |t|
      t.datetime :time
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.integer :timeframe
      t.references :symb, foreign_key: true

      t.timestamps
    end
  end
end
