class RenameSeedsColumn < ActiveRecord::Migration
  def change
  	rename_column(:seeds, 'memmory','memory')
  end
end
