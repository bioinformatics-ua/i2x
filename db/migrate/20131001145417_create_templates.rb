class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :identifier
      t.text :title
      t.text :help
      t.string :publisher
      t.text :payload
      t.text :memory
      t.integer :count
      t.integer :status, :default => 100
      t.datetime :last_execute_at
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end

    add_index :templates, :identifier, :unique => true
  end
end
