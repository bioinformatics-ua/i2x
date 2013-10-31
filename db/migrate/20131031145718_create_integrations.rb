class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :identifier
      t.string :title
      t.text :help
      t.text :payload
      t.text :memory

      t.timestamps
    end
  end
end
