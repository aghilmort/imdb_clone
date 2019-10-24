class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.string :image_url, limit: 2048

      t.timestamps
    end
  end
end
