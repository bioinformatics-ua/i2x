class AddSeedToCache < ActiveRecord::Migration
  def change
  	add_column :caches, :seed, :string
  end
end
