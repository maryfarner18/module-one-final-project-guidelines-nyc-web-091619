class CreatingWalkerTable < ActiveRecord::Migration[5.2]
  def change
    create_table :walkers do |t|
      t.string :name
      t.integer :experience
      t.decimal :average_rating
      t.timestamps
    end
  end
end

#Name, Experience, Avg Rating