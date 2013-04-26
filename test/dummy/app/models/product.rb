class Product < ActiveRecord::Base
	extend Crimagify::DinamicImageMethods
	#proximo paso que esto sea dinamico en un generate
	has_many :crimagify_images, :as => :parent, :dependent => :destroy, :class_name => Crimagify::Image
	belongs_to :user
  attr_accessible :description, :name, :user_id
  #===========================building methods dinamically===========================#
  #y esto tambien tiene que ser dinamico en los generators
  build_methods_images
  #==================================================================================#
end
