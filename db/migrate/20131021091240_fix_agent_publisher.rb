class FixAgentPublisher < ActiveRecord::Migration
  def change
  	rename_column :agents, :type, :publisher
  end
end
