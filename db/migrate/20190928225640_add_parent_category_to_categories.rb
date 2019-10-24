class AddParentCategoryToCategories < ActiveRecord::Migration[6.0]
  def change
  	add_column :categories, :parent_category, :string
  end
end
