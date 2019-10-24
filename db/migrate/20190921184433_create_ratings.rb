class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :scale
      t.references :user, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
