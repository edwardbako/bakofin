class CreateSpecifications < ActiveRecord::Migration[5.1]
  def change
    create_table :specifications do |t|
      t.string :symbol, null: false, index: true
      t.integer :precision
      t.integer :stoploss_level
      t.integer :lot_size
      t.string :margin_currency, default: "USD", null: false
      t.string :orders_currency
      t.integer :leverage
      t.float :minimum_lot_size, precision: 2
      t.float :maximum_lot_size, precision: 2
      t.float :lot_size_step, precision: 2
      t.float :short_swap
      t.float :long_swap

      t.timestamps
    end
  end
end
