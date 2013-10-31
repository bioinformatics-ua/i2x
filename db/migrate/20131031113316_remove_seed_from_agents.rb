class RemoveSeedFromAgents < ActiveRecord::Migration
  def change
  	remove_column(:agents,'seed')
  end
end
