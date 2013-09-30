class CreateStds < ActiveRecord::Migration
  def change
    create_table :stds do |t|
      t.string :key
      t.string :label
      t.string :help
      t.integer :visited

      t.timestamps
    end
  end
end
