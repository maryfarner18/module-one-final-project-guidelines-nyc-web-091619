class CreateDogsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :breed
      t.decimal :age
      t.string :gender
      t.text :notes
      t.integer :owner_id
      t.timestamps

    end
  end
end
