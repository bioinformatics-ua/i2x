class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :identifier
      t.string :title
      t.text :help
      t.text :payload
      t.text :memory
      t.integer :status, :default => 100

      t.timestamps
    end

    add_index :integrations, :identifier, :unique => true
  end
end
