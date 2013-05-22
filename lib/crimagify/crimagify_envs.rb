module Crimagify
	module CrimagifyEnvs
		extend ActiveSupport::Concern
		extend Crimagify::ImageFunctions

		included do
			extend Crimagify::DinamicImageMethods
			puts "se han incluido los callbacks"
			has_many :crimagify_images, :as => :parent, :dependent => :destroy, :class_name => Crimagify::Image
			after_initialize :generate_attrs
			around_update :save_images
			# after_create :save_images
			after_save :save_images
			# after_find :build_methods_images
			build_methods_images			
		end

		def generate_attrs
	    CRIMAGIFY_ENV["#{self.class.name}"].each do |image_name|
	    	data = %w(image_temporal crop_x crop_y crop_w crop_h)
	    	data.each do |attr_acc|
	    		name_accesible = "#{image_name[0]}_#{attr_acc}"
	    		self.class.send(:attr_accessible, "#{name_accesible}")
	    		self.class.send(:attr_accessor, "#{name_accesible}")
	    	end
	    	self.class.send(:attr_accessible, "parent")
	    	self.class.send(:attr_accessible, "parent_id")
	    	self.class.send(:attr_accessible, "id_images")
	    	self.class.send(:attr_accessor, "parent")
	    	self.class.send(:attr_accessor, "parent_id")
	    	self.class.send(:attr_accessor, "id_images")
	    end
		end

		def save_images			
			parameters = {}
			CRIMAGIFY_ENV["#{self.class.name}"].each do |image_name|
	    	data = %w(image_temporal crop_x crop_y crop_w crop_h)
	    	data.each do |attr_acc|
	    		if !eval("#{image_name[0]}_image_temporal").blank? && !eval("#{image_name[0]}_image_temporal").nil?
	    			name_accesible = "#{image_name[0]}_#{attr_acc}"
	    			parameters[name_accesible.to_sym] = eval("#{name_accesible}")
	    		end
	    	end	    	
	    end
	    if !parameters.empty?
	    	puts "me llamaron despues de actualizar"
	    	parameters[:parent] = self.parent
	    	parameters[:parent_id] = self.parent_id
	    	parameters[:id_images] = self.id_images
	    	parameters.inspect
	    	# Crimagify::ImageFunctions::generate_image(self, @parameters)
	    	generate_image(self, parameters)
	    end
			puts "me llamaron esta vez, porque acabo de guardar un producto y sus imagenes imagen"
		end

	end
end