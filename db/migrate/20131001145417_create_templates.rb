class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :identifier
      t.text :title
      t.text :help
      t.string :publisher
      t.text :variables
      t.text :payload
      t.text :memory
      t.integer :count
      t.datetime :last_execute_at
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
