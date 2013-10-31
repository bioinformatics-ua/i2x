class AddIntegrationMappings < ActiveRecord::Migration
     create_table :integration_mappings do |t|
      t.belongs_to :integration
      t.belongs_to :template
      t.timestamps
    end
end