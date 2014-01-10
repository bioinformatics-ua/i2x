class CreateUserTemplate < ActiveRecord::Migration
  def change
    create_table :user_templates do |t|
      t.belongs_to :user
      t.belongs_to :template
      t.integer :status, :default => 100
      t.timestamps
    end
  end
end