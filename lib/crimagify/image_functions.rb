module Crimagify
	module ImageFunctions

		def write_tmp_image(image, parent_id, parent_type, image_name, parent_fieldset = nil)
		    require 'base64'
		    image_encoded = image.split(",")      
		    extension = image_encoded[0].split("/")[1].split(";")[0]

		    today = Time.now
		    generate_name = "#{today.strftime("%Y-%m-%d")}-#{parent_type}-#{image_name}-#{parent_id}"

		    path = nil
		    if parent_fieldset.nil?
		    	path = "#{Rails.root}/app/assets/images/tmps_cropper/#{parent_type}/image_temporal/#{parent_id}/#{image_name}"
		    else
		    	path = "#{Rails.root}/app/assets/images/tmps_cropper/#{parent_type}/image_temporal/#{parent_id}/#{parent_fieldset}/#{image_name}"
		    end

		    if !File.exist?(path)
		      FileUtils.mkdir_p(path)
		    end

		    File.open("#{path}/#{generate_name}.#{extension}", "wb") do |item|
		      item << (Base64.decode64(image_encoded[1]))
		    end

		    return "#{path}/#{generate_name}.#{extension}"
		end

		def get_data_parent(parent, parent_id)
			if !(parent_id.to_i == 0)
				parent_model = parent.constantize
				data = parent_model.find(parent_id.to_i)
		    else
		      data = 0
		    end
		    return data
		end

		def save_new_image(path, x, y, w, h, parent_type, parent_id, image_name, temporal)
			data = {:crop_x => x,
							:crop_y => y,
							:crop_w => w,
							:crop_h => h,
							:parent_type => parent_type,
							:parent_id => parent_id,
							:image_name => image_name
			}
			data[(temporal ? :image_temporal : :image)] = File.open(path)

			return Image.new(data)
		end

		def generate_image(object, params = {})

			images = object.crimagify_images
			id_array = []
			
			params.each do |key, value|
				if value != "" && !value.nil?
					key_split = key.to_s
					name = key_split.split("_")
					length = name.length.to_i
					if "#{name[length-2]}_#{name[length-1]}" == "image_temporal"
						id_array << name[0..(length - 3)].join("_").to_s
					end
				end
			end
			
			if images.empty?
				id_array.map { |image_name|
					path = ""
					params.each do |key, value|
						if value != "" && !value.nil?
							if key.to_s == "#{image_name}_image_temporal"
								path = value.to_s
							end
						end
					end
					if path.to_s != "" && File.exist?(path.to_s)
						img = save_new_image(path.to_s,
																 params["#{image_name}_crop_x".to_sym],
																 params["#{image_name}_crop_y".to_sym],
																 params["#{image_name}_crop_w".to_sym],
																 params["#{image_name}_crop_h".to_sym],
																 object.class.name,
																 object.id,
																 image_name,
																 false)
						img.save!
						img.crop_avatar_real
					end
				}
			else
				id_array.map { |image_name|
					path = ""
					params.each do |key, value|
						if !value.empty? && !value.nil?
							if key.to_s == "#{image_name}_image_temporal"
								path = value.to_s
							end							
						end
					end
					if path.to_s != "" && File.exist?(path.to_s)
						data_image = {:image => File.open(path.to_s),
													:crop_x => params["#{image_name}_crop_x".to_sym],
													:crop_y => params["#{image_name}_crop_y".to_sym],
													:crop_w => params["#{image_name}_crop_w".to_sym],
													:crop_h => params["#{image_name}_crop_h".to_sym]
						}
						img = images.where("image_name=?", image_name).first
						if img.nil?
							img = save_new_image(path.to_s,
																	 params["#{image_name}_crop_x".to_sym],
																	 params["#{image_name}_crop_y".to_sym],
																	 params["#{image_name}_crop_w".to_sym],
																	 params["#{image_name}_crop_h".to_sym],
																	 object.class.name,
																	 object.id,
																	 image_name,
																	 false)
							img.save!
							img.crop_avatar_real
						else
							img.update_attributes(data_image)
							img.crop_avatar_real
						end
					end
				}
			end			
		end
	end
end