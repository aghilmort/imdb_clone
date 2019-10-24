class AddUniqueIndexToCategories < ActiveRecord::Migration[6.0]
  def change
  	add_index :categories, [:title, :parent_category], unique: true
  end
end
