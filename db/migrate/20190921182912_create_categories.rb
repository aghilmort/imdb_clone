class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :type
      t.text :description
      t.string :image_url, limit: 2048

      t.timestamps
    end
  end
end
