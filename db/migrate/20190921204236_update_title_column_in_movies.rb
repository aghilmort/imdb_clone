class UpdateTitleColumnInMovies < ActiveRecord::Migration[6.0]
	def self.up
	  change_column :movies, :title, :string, null: false
  end
 
  def self.down
  	change_column :movies, :title, :string, null: true
	end
end
