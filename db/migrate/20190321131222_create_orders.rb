class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :symbol
      t.integer :kind
      t.datetime :open_date
      t.datetime :close_date

      t.float :lot_size

      t.float :open_price_cents
      t.string :open_price_currency

      t.float :close_price_cents
      t.string :close_price_currency

      t.float :stop_loss_cents
      t.string :stop_loass_currency

      t.float :take_profit_cents
      t.string :take_profit_currency

      t.integer :slippage
      t.text :comment
      t.string :magic_number
      t.datetime :expiration

      t.float :profit_cents
      t.string :profit_currency

      t.float :swap_cents
      t.string :swap_currency

      t.float :commission_cents
      t.string :commission_currency

      t.references :account

      t.timestamps
    end
  end
end
