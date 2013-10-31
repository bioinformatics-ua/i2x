class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.string :identifier
      t.string :title
      t.string :publisher
      t.text :help
      t.text :payload
      t.text :memmory

      t.timestamps
    end
  end
end
