class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :login
      t.string :password_digest
      t.string :server
      t.references :test_pass

      t.timestamps
    end
  end
end
