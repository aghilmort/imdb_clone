class UpdateColumnRatingInRatings < ActiveRecord::Migration[6.0]
	def self.up
	  rename_column :ratings, :rating, :score
  end
 
  def self.down
	  rename_column :ratings, :score, :rating
	end
end
