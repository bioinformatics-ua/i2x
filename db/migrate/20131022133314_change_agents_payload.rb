class ChangeAgentsPayload < ActiveRecord::Migration
  def change
  	rename_column :agents, :options, :payload
  end
end
