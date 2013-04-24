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
			html << content_tag(:input, nil, :id => :parent, :name => :parent, :type => :hidden, :value => "#{object.class.name}")
			html << content_tag(:input, nil, :id => :parent_id, :name => :parent_id,  :type => :hidden, :value => "#{object.id}")
			html << content_tag(:input, nil, :id => :id_images, :name => :id_images, :type => :hidden, :value => "")
			return raw html
		end
  end
end
