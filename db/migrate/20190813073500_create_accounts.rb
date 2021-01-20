class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :login
      t.string :password
      t.string :server
      t.string :name
      t.string :company
      t.string :currency
      t.integer :leverage
      t.integer :stopout_level
      t.integer :stopout_mode
      t.float :balance
      t.float :credit
      t.float :equity
      t.float :margin
      t.float :free_margin

      t.references :test_pass

      t.timestamps
    end
  end
end
