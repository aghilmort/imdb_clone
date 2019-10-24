class UpdateTypeColumnInCategories < ActiveRecord::Migration[6.0]
	def self.up
		rename_column :categories, :type, :title
	  change_column :categories, :title, :string, null: false
  end
 
  def self.down
  	change_column :categories, :title, :string, null: true
  	rename_column :categories, :title, :type
	end
end
