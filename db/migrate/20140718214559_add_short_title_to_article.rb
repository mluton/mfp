class AddShortTitleToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :short_title, :string
  end
end
