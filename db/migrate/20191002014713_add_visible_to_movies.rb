class AddVisibleToMovies < ActiveRecord::Migration[6.0]
  def change
  	add_column :movies, :visible, :boolean, null: false, default: true
  end
end
