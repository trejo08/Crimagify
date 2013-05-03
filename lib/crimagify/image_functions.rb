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

		    puts "ruta creada para guardar"
		    puts path

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

		def update_images(object, params = {})
			if params[:id_images] != ""
				id_array = params[:id_images].split(",")

				id_array.map { |image_name|
					path = params["image_temporal_#{image_name}"]
					if !(path.to_s == "") && File.exist?(path.to_s)
						image = object.crimagify_images.where("image_name=?", image_name)
						if !(image == [])
							image.map { |img|  
								img.update_attributes(:image => File.open(path.to_s),
																			:crop_x => params["#{image_name}_crop_x"],
																			:crop_y => params["#{image_name}_crop_y"],
																			:crop_w => params["#{image_name}_crop_w"],
																			:crop_h => params["#{image_name}_crop_h"])
								img.crop_avatar_real
							}
						else
							img = save_new_image(path,
																	 params["#{image_name}_crop_x"],
																	 params["#{image_name}_crop_y"],
																	 params["#{image_name}_crop_w"],
																	 params["#{image_name}_crop_h"],
																	 object.class.name,
																	 object.id,
																	 image_name,
																	 false)
							img.save!
							img.crop_avatar_real
						end
					end
				}				
			end			
		end

		def create_new_images(object, params)
			id_array = params[:id_images].split(",")
			id_array.map { |image_name|
				path = params["image_temporal_#{image_name}"]
				if !(path.to_s == "") && File.exist?(path.to_s)
					img = save_new_image(path.to_s,
															 params["#{image_name}_crop_x"],
															 params["#{image_name}_crop_y"],
															 params["#{image_name}_crop_w"],
															 params["#{image_name}_crop_h"],
															 object.class.name,
															 object.id,
															 image_name,
															 false)
					img.save!
					img.crop_avatar_real
				end
			}
		end
	end
end