class CreateSymbs < ActiveRecord::Migration[5.1]
  def change
    create_table :symbs do |t|
      t.string :name

      t.timestamps
    end
  end
end
