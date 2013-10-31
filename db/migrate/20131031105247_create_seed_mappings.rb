class CreateSeedMappings < ActiveRecord::Migration
  def change
    create_table :seed_mappings do |t|
    	t.belongs_to :agent
      	t.belongs_to :seed
      	t.timestamps
    end
  end
end
