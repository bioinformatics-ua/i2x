class AddStatusToSeeds < ActiveRecord::Migration
  def change
    add_column :seeds, :status, :integer
  end
end
