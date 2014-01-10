class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :apikey, :string
    add_column :users, :status, :integer, :default => 100
  	add_column :users, :image, :string
  	add_column :users, :location, :string
  end
end
