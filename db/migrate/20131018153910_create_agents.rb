class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :type
      t.text :options
      t.text :memory
      t.string :identifier
      t.string :title
      t.text :help
      t.string :schedule
      t.integer :events_count
      t.datetime :last_check_at
      t.datetime :last_event
      t.text :seed
      t.datetime :created_at
      t.datetime :updated_at
      t.string :action

      t.timestamps
    end
  end
end
