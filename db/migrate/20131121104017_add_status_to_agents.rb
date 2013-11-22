class AddStatusToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :status, :integer
  end
end
