class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :payload
      t.text :memory
      t.integer :agent_id
      t.integer :status
      t.timestamps
    end
  end
end
