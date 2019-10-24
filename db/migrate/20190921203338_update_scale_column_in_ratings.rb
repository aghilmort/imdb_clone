class UpdateScaleColumnInRatings < ActiveRecord::Migration[6.0]
	def self.up
	  rename_column :ratings, :scale, :rating
	  change_column :ratings, :rating, :integer, null: false
  end
 
  def self.down
  	change_column :ratings, :rating, :integer, null: true
	  rename_column :ratings, :rating, :scale
	end
end
