class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :refseq
      t.string :gene
      t.string :variant
      t.string :url

      t.timestamps
    end
  end
end
