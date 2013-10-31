class RemoveActionFromAgents < ActiveRecord::Migration
  def change
  	remove_column(:agents,'action')
  end
end
