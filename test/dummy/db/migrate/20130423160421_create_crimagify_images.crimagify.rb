# This migration comes from crimagify (originally 20130422223133)
class CreateCrimagifyImages < ActiveRecord::Migration
  def change
    create_table :crimagify_images do |t|
      t.string :image, :default => "", :null => false
      t.string :image_temporal, :default => "", :null => false
      t.string :image_name, :default => "", :null => false
      t.references :parent, :polymorphic => true

      t.timestamps
    end
    add_index :crimagify_images, :parent_id
  end
end
