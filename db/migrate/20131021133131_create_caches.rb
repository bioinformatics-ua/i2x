class CreateCaches < ActiveRecord::Migration
  def change
    create_table :caches do |t|
      t.string :publisher
      t.belongs_to :agent
      t.text :payload
      t.text :memory

      t.timestamps
    end

    add_index :caches, :id
  end
end
