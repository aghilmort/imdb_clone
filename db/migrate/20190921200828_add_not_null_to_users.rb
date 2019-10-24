class AddNotNullToUsers < ActiveRecord::Migration[6.0]
	def self.up
	  change_column :users, :name, :string, null: false
	  change_column :users, :role, :string, null: false
  end
 
  def self.down
	  change_column :users, :name, :string, null: true
	  change_column :users, :role, :string, null: true
	end
end
