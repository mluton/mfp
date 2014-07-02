class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :deck
      t.text :description
      t.integer :ordinal

      t.timestamps
    end
  end
end
