module Crimagify
  module ApplicationHelper
  	def image_cropper(object, options, image_options = {})
			img = object.crimagify_images.where("image_name=?", options[:image_name])
			if img == []
				url_image = "rails.png"
			else
				url_image = img.first.image_url(options[:ratio]).to_s rescue ""
			end
			render(:partial => "crimagify/crop_partials/fields_cropper", :locals => { id_image: options[:image_name], url_image: url_image, image_options: image_options })
		end
		def images_id(object)
			html = ""
			html << 
			puts object.class.name
			hidden_field_tag :parent, nil, :value => "#{object.class.name}", :id => "parent"
			hidden_field_tag :parent_id, nil, :value => object.id, :id => "parent_id"
			hidden_field_tag :id_images, nil, :value => ""
		end
  end
end
