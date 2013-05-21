class User < ActiveRecord::Base
	# extend Crimagify::DinamicImageMethods
  # include Crimagify::CrimagifyEnvs
	#proximo paso que esto sea dinamico en un generate
	# has_many :crimagify_images, :as => :parent, :dependent => :destroy, :class_name => Crimagify::Image
	has_many :products

  attr_accessible :email, :lastname, :name
  attr_accessible :products_attributes

  accepts_nested_attributes_for :products, allow_destroy: true

  #===========================building methods dinamically===========================#
  #y esto tambien tiene que ser dinamico en los generators
  # build_methods_images
  #==================================================================================#
end
