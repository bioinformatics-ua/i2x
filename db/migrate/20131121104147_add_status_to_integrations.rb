class AddStatusToIntegrations < ActiveRecord::Migration
  def change
    add_column :integrations, :status, :integer
  end
end
