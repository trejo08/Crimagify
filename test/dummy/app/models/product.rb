class Product < ActiveRecord::Base
	extend Crimagify::DinamicImageMethods
	#proximo paso que esto sea dinamico en un generate
	has_many :crimagify_images, :as => :parent, :dependent => :destroy, :class_name => Crimagify::Image
	belongs_to :user
  attr_accessible :description, :name, :user_id

  
  # attr_accessible :crop_x, :crop_y, :crop_w, :crop_h, :parent, :parent_id, :id_images
  # attr_accessor :user_id, :crop_x, :crop_y, :crop_w, :crop_h, :parent, :parent_id, :id_images, :image_temporal_imgA, :imgA_crop_x, :imgA_crop_y, :imgA_crop_w, :imgA_crop_h, :image_temporal_imgB
  #===========================building methods dinamically===========================#
  #y esto tambien tiene que ser dinamico en los generators
  build_methods_images
  #==================================================================================#
end
