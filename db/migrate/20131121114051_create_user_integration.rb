class CreateUserIntegration < ActiveRecord::Migration
  def change
    create_table :user_integrations do |t|
      t.belongs_to :user
      t.belongs_to :integration
      t.integer :status
      t.timestamps
    end
  end
end