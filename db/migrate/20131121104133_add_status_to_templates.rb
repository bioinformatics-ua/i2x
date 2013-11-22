class AddStatusToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :status, :integer
  end
end
