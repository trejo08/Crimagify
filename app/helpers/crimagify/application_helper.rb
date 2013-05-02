module Crimagify
	module ApplicationHelper

	  	def image_cropper(object, options, image_options = {})
			image_options[:class] = "#{image_options[:class]} img_start"
			img = object.crimagify_images.where("image_name=?", options[:image_name])
			version_name = options[:ratio]
			if img == []
				url_image = "rails.png"
			else
				url_image = img.first.image_url(options[:ratio]).to_s rescue ""
			end
			if url_image == ""
				url_image = "rails.png"
			end
			render(:partial => "crimagify/crop_partials/fields_cropper", :locals => { id_image: options[:image_name], url_image: url_image, image_options: image_options, version_name: version_name })
		end

		def images_id(object)
			html = ""
			html << content_tag(:input, nil, :id => :parent, :name => :parent, :type => :hidden, :value => "#{object.class.name}")
			html << content_tag(:input, nil, :id => :parent_id, :name => :parent_id,  :type => :hidden, :value => "#{object.id}")
			html << content_tag(:input, nil, :id => :id_images, :name => :id_images, :type => :hidden, :value => "")
			return raw html
		end

		def nested_image_cropper(object, options, image_options = {})
			image_options[:class] = "#{image_options[:class]} img_start"
			img = object.crimagify_images.where("image_name=?", options[:image_name])
			version_name = options[:ratio]
			if img == []
				url_image = "rails.png"
			else
				url_image = img.first.image_url(options[:ratio]).to_s rescue ""
			end
			if url_image == ""
				url_image = "rails.png"
			end
			render(:partial => "crimagify/crop_partials/nested_cropper", :locals => { id_image: options[:image_name], url_image: url_image, image_options: image_options, version_name: version_name })
		end

		def nested_images_id(object)
			html = ""
			html << content_tag(:input, nil, :class => :parent, :name => :parent, :type => :hidden, :value => "#{object.class.name}")
			html << content_tag(:input, nil, :class => :parent_id, :name => :parent_id,  :type => :hidden, :value => "#{object.id}")
			html << content_tag(:input, nil, :class => :id_images, :name => :id_images, :type => :hidden, :value => "")
			return raw html
		end

		def link_to_add_fields(name, f, association)
		  new_object = f.object.send(association).klass.new
		  #data variables
		  parent_object = f.object.class.name.underscore
		  id = new_object.object_id
		  tag_parent = association.to_s

		  fields = f.fields_for(association, new_object, child_index: id) do |builder|
		    render(association.to_s.singularize + "_fields", f: builder)
		  end
		    
		  link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", ""), parent: tag_parent, parentobject: parent_object})
		end
	end
end
