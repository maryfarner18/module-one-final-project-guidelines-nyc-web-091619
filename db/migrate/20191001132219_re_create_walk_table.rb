class ReCreateWalkTable < ActiveRecord::Migration[5.2]
  def change
    create_table :walks do |t|
      t.integer :dog_id
      t.integer :walker_id
      t.datetime :date_and_time
      t.integer :length
      t.string :status
      t.decimal :rating
    end
  end
end
