require 'active_support/core_ext'
module Crimagify
	module DinamicImageMethods

		extend ActiveSupport::Concern

		def build_methods_images
			array_methods = []
			CRIMAGIFY_ENV["#{self.name}"].each do |item|
				array_methods << item.first
			end if !CRIMAGIFY_ENV.empty?

			array_methods.each do |name|
				define_method("#{name}") do
					img = crimagify_images.find_by_image_name("#{name}")
					if img == nil
						img = Crimagify::Image.all.first						
					end
					return img
				end
			end
		end

		def build_sizes_images
			array_versions = []
	    CRIMAGIFY_ENV.each do |image_name|
	    	image_name[1].each do |name|
	    		name_version = name[1]
	    		name_version.each do |item|
	    			array_versions << item.first
	    		end
	    	end
	    end if !CRIMAGIFY_ENV.empty?

	    array_versions = array_versions.uniq
	    array_versions.each do |name_size|
	    	size_image = name_size.to_sym
	    	define_method("#{name_size}") do
	    		image_path_return = image_url(size_image)
	    		if image_path_return.blank?
	    			if ENV['DEFAULT_IMAGE'].nil?
	    				image_path_return = "crimagify/no_selected_image.jpg"
	    			else
	    				image_path_return = ENV['DEFAULT_IMAGE']
	    			end
	    		end
	    		return image_path_return
	    	end
	    end if !array_versions.empty?

	    define_method("original_picture") do
	    	image_path_return = image_url
	    	if image_path_return.blank?
	    		if ENV['DEFAULT_IMAGE'].nil?
	    			image_path_return = "crimagify/no_selected_image.jpg"
	    		else
	    			image_path_return = ENV['DEFAULT_IMAGE']
	    		end
	    	end
	    	return image_path_return
	    end
	  end
	end
end