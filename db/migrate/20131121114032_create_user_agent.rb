class CreateUserAgent < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.belongs_to :user
      t.belongs_to :agent
      t.integer :status
      t.timestamps
    end
  end
end