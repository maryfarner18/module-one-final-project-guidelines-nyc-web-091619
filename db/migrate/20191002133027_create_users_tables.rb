class CreateUsersTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :user_type
    end  
  end
end
