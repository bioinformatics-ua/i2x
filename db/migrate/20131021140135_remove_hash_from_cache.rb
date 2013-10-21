class RemoveHashFromCache < ActiveRecord::Migration
  def change
    remove_column :caches, :hash
  end
end
