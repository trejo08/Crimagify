module Crimagify
	module CrimagifyEnvs
		extend ActiveSupport::Concern

		included do
			puts "se han incluido los callbacks"
			after_initialize :generate_attrs
			after_save :save_images
		end

		def generate_attrs
	    CRIMAGIFY_ENV["#{self.class.name}"].each do |image_name|
	    	data = %w(image_temporal crop_x crop_y crop_w crop_h)
	    	data.each do |attr_acc|
	    		name_accesible = "#{image_name[0]}_#{attr_acc}"
	    		self.class.send(:attr_accessible, name_accesible)
	    		self.class.send(:attr_accessor, name_accesible)
	    	end
	    	self.class.send(:attr_accessible, "parent")
	    	self.class.send(:attr_accessible, "parent_id")
	    	self.class.send(:attr_accessible, "id_images")
	    	self.class.send(:attr_accessor, "parent")
	    	self.class.send(:attr_accessor, "parent_id")
	    	self.class.send(:attr_accessor, "id_images")
	    end
		end

		def build_methods_images
			array_methods = []
			CRIMAGIFY_ENV["#{self.class.name}"].each do |item|
				array_methods << item.first
			end

			array_methods.each do |name|
				puts "soy el item #{name}"
				# define_method("#{name}") do
				# 	img = crimagify_images.find_by_image_name("#{name}")# rescue ""
				# 	if img == nil
				# 		return []
				# 	else
				# 		return img
				# 	end
				# end
			end
		end

		def save_images			
			params = {}
			CRIMAGIFY_ENV["#{self.class.name}"].each do |image_name|
	    	data = %w(image_temporal crop_x crop_y crop_w crop_h)
	    	puts self.inspect
	    	data.each do |attr_acc|
	    		puts "este es el valor del crop_x: #{self.imgA_crop_x}"
	    		puts "este es el valor del crop_x: #{image_name[0]}_crop_x"
	    		name_accesible = "#{image_name[0]}_#{attr_acc}"
	    		params[name_accesible.to_sym] = self[name_accesible.to_sym]
	    		# params[name_accesible.to_s] = get_attr_acc(name_accesible)
	    	end
	    end
	    puts "este sera el params que voy a enviar: #{params.to_yaml}"
			# Crimagify::ImageFunctions::update_images(self, object_params, object_has_nested)
		end

		def get_attr_acc(accessor)
			puts self["#{accessor.to_s}"].inspect
			value = self["#{accessor.to_s}"]
			return value
		end

	end
end