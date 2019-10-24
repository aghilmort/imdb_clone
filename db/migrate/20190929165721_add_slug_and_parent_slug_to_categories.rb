class AddSlugAndParentSlugToCategories < ActiveRecord::Migration[6.0]
  def change
  	add_column :categories, :slug, :string, unique: true, null: false
  	add_column :categories, :sub_category_slug, :string

  	remove_index :categories, [:title, :parent_category]
  	add_index :categories, [:slug, :sub_category_slug], unique: true

  	rename_column :categories, :title, :sub_category_title
  	change_column_null :categories, :sub_category_title, null: true
  	rename_column :categories, :parent_category, :title
  end
end
