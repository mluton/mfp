class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :category_id
      t.text :description
      t.text :body
      t.integer :ordinal

      t.timestamps
    end
  end
end
