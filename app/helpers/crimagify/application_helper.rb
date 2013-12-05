module Crimagify
	module ApplicationHelper

  	def image_cropper(object, options, image_options = {})
			
			image_options[:class] = "#{image_options[:class]} img_start"			
			img = object.crimagify_images.where("image_name=?", options[:image_name])
			version_name = options[:ratio]

			if options[:label_title].nil?
				options[:label_title] = "Image"
			end
			
			if options[:choose_text].nil?
				options[:choose_text] = "Choose image"
			end
			
			if img == []
				url_image = "crimagify/no_selected_image.jpg"
			else
				url_image = img.first.image_url(options[:ratio]).to_s rescue ""
			end
			
			if url_image == ""
				if ENV['DEFAULT_IMAGE'].nil?
					url_image = "crimagify/no_selected_image.jpg"
				else
					url_image = ENV['DEFAULT_IMAGE'].to_s
				end
			end

			parent_image = object.class.name.underscore
			parent_split = parent_image.split("/")
			if parent_split.length.to_i == 2
				parent_image = parent_split[1]
			end
			render(:partial => "crimagify/crop_partials/fields_cropper", :locals => { id_image: options[:image_name], url_image: url_image, image_options: image_options, version_name: version_name, label_title: options[:label_title], choose_text: options[:choose_text], parent_image: parent_image })
		end

		def images_id(object)
			parent = object.class.name.underscore
			parent_split = parent.split("/")
			if parent_split.length.to_i == 2
				parent = parent_split[1]
			end
			html = ""
			html << content_tag(:input, nil, :id => :parent, :name => "#{parent}[parent]", :type => :hidden, :value => "#{object.class.name}")
			html << content_tag(:input, nil, :id => :parent_id, :name => "#{parent}[parent_id]",  :type => :hidden, :value => "#{object.id}")
			html << content_tag(:input, nil, :id => :id_images, :name => "#{parent}[id_images]", :type => :hidden, :value => "")
			html << content_tag(:input, nil, :class => :crimagify_schema, :name => "#{parent}[crimagify_schema]", :type => :hidden, :value => "")
			return raw html
		end

		def nested_image_cropper(object, options, image_options = {})
			image_options[:class] = "#{image_options[:class]} img_start"
			img = object.crimagify_images.where("image_name=?", options[:image_name])
			version_name = options[:ratio]
			if options[:label_title].nil?
				options[:label_title] = "Image"
			end
			if options[:choose_text].nil?
				options[:choose_text] = "Choose image"
			end
			if img == []
				if ENV['DEFAULT_IMAGE'].nil?
					url_image = "crimagify/no_selected_image.jpg"
				else
					url_image = ENV['DEFAULT_IMAGE'].to_s
				end						
			else
				url_image = img.first.image_url(options[:ratio]).to_s rescue ""
			end
			if url_image == ""
				if ENV['DEFAULT_IMAGE'].nil?
					url_image = "crimagify/no_selected_image.jpg"
				else
					url_image = ENV['DEFAULT_IMAGE'].to_s
				end
			end
			render(:partial => "crimagify/crop_partials/nested_cropper", :locals => { id_image: options[:image_name], url_image: url_image, image_options: image_options, version_name: version_name, label_title: options[:label_title], choose_text: options[:choose_text]  })
		end

		def nested_images_id(object)
			# parent = object.class.name.underscore
			# parent_split = parent.split("/")
			# if parent_split.length.to_i == 2
			# 	parent = parent_split[1]
			# end
			html = ""
			html << content_tag(:input, nil, :class => :parent, :name => :parent, :type => :hidden, :value => "#{object.class.name}")
			html << content_tag(:input, nil, :class => :parent_id, :name => :parent_id,  :type => :hidden, :value => "#{object.id}")
			html << content_tag(:input, nil, :class => :id_images, :name => :id_images, :type => :hidden, :value => "")
			html << content_tag(:input, nil, :class => :nested_crimagify_schema, :name => :crimagify_schema, :type => :hidden, :value => "")
			return raw html
		end

		def link_to_add_nested_fields(name, f, association, options = {})
		  new_object = f.object.send(association).klass.new
		  parent_object = f.object.class.name.underscore
		  id = new_object.object_id
		  tag_parent = association.to_s

		  fields = f.fields_for(association, new_object, child_index: id) do |builder|
		    render(association.to_s.singularize + "_fields", f: builder)
		  end
		    
		  link_to(name, '#', class: "add_crimgify_fields #{options[:class]}", data: {id: id, fields: fields.gsub("\n", ""), parent: tag_parent, parentobject: parent_object})
		end
	end
end
