class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :symbol
      t.integer :kind
      t.datetime :open_date
      t.float :lot_size
      t.monetize :open_price
      t.monetize :close_price
      t.datetime :close_date
      t.monetize :stop_loss
      t.monetize :take_profit
      t.integer :slippage
      t.text :comment
      t.string :magic_number
      t.datetime :expiration
      t.references :account

      t.timestamps
    end
  end
end
