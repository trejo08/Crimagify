module Crimagify
  class Image < ActiveRecord::Base
  	require 'carrierwave/orm/activerecord'
  	extend Crimagify::DinamicImageMethods

  	mount_uploader :image, Crimagify::ImageUploader
		mount_uploader :image_temporal, Crimagify::ImageUploader

		belongs_to :parent, polymorphic: true
    attr_accessible :image, :image_name, :image_temporal, :parent_id, :parent_type, :crop_x, :crop_y, :crop_w, :crop_h

    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    def crop_avatar_temporal
    	puts "esta entrando a la funcion de crop temporal"
	  	# if image_temporal.present?
	  		if crop_x.nil?
	  			puts "el crop x es nil"
	  			puts crop_x	  			
	  			image_temporal.recreate_versions! if crop_x.present?
	  		else
	  			puts "el crop x no es nil"
	  			image_temporal.recreate_versions! if crop_x.present?
	  		end
	  	# end
	  end

	  def crop_avatar_real
	  	if crop_x.nil?
	  		puts "el crop x es nil"
	  		image.recreate_versions! if crop_x.present?
	  	else
	  		image.recreate_versions! if crop_x.present?
	  	end
	  	# image.recreate_versions! if crop_x.present?
	  end

	  build_sizes_images
	  
  end
end
