class AddUsernameToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :image, :string
  	add_column :users, :location, :string
  end
end
