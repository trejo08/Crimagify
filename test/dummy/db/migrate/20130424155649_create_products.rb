class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :default => "", :null => false
      t.string :description, :default => "", :null => false

      t.timestamps
    end
  end
end
