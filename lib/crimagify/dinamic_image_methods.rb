require 'active_support/core_ext'
module Crimagify
	module DinamicImageMethods

		extend ActiveSupport::Concern 

		def build_methods_images(methods = nil)
			array_methods = []
			CRIMAGIFY_ENV["#{self.name}"].each do |item|
				array_methods << item.first
			end

			array_methods.each do |name|
				define_method("#{name}") do
					img = crimagify_images.find_by_image_name("#{name}")# rescue ""
					if img == nil
						return []
					else
						return img
					end
				end
			end
		end

		def build_sizes_images#(methods = nil)
			array_versions = []
	    CRIMAGIFY_ENV.each do |image_name|
	    	image_name[1].each do |name|
	    		name_version = name[1]
	    		name_version.each do |item|
	    			array_versions << item.first
	    		end
	    	end
	    end

	    array_versions = array_versions.uniq
	    array_versions.each do |name_size|
	    	size_image = name_size.to_sym
	    	define_method("#{name_size}") do
	    		image_url(size_image) rescue ""
	    	end
	    end
	  end
	end
end