class CreatingWalkTable < ActiveRecord::Migration[5.2]
  def change
    create_table :walks do |t|
      t.integer :dog_id
      t.integer :walker_id
      t.datetime :date_and_time
      t.integer :length
      t.string :status
      t.float :rating
    end
  end
end

#Dog_id, Walker_id, Date, Time, Price, Length, Status (Upcoming, In Progress, Complete)
