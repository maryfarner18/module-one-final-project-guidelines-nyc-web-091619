class CreateOwnersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :name
      t.string :address
    end
  end
end
