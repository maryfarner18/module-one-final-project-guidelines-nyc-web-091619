class CreateOwnersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :name
      t.text :address
      t.integer :user_id
      t.timestamps
    end
  end
end
