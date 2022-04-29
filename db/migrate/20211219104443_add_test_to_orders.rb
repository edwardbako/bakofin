class AddTestToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :test, :boolean, default: false
  end
end
