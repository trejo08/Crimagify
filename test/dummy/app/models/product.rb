class Product < ActiveRecord::Base
	extend Crimagify::DinamicImageMethods
	#proximo paso que esto sea dinamico en un generate
	has_many :crimagify_images, :as => :parent, :dependent => :destroy, :class_name => Crimagify::Image
  attr_accessible :description, :name
  #===========================building methods dinamically===========================#
  #y esto tambien tiene que ser dinamico en los generators
  build_methods_images
  #==================================================================================#
end
