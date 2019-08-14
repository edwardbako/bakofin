class CreateTestPasses < ActiveRecord::Migration[5.1]
  def change
    create_table :test_passes do |t|
      t.string :symbol
      t.integer :timeframe
      t.datetime :start_date
      t.datetime :stop_date
      t.string :strategy
      t.integer :bars_processed

      t.timestamps
    end
  end
end
