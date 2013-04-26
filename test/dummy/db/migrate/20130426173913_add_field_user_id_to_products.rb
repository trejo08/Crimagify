class AddFieldUserIdToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :user_id, :integer, :default => 0, :null => false
  	add_index :products, :user_id
  end
end
