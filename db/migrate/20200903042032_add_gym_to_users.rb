class AddGymToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gym, :string
  end
end
