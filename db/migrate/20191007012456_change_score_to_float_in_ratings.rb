class ChangeScoreToFloatInRatings < ActiveRecord::Migration[6.0]
  def change
  	change_column :ratings, :score, :decimal, precision: 3, scale: 1
  end
end