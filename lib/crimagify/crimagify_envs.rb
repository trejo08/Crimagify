module Crimagify
	module CrimagifyEnvs
		extend ActiveSupport::Concern

		included do
			after_find :build_methods_images
		end

		def build_methods_images
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
		
	end
end