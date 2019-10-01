class DropWalkTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :walks
  end
end
