class AddHistoryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :history, :string
  end
end
