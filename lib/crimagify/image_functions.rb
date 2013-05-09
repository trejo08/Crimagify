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

		def update_images(object, params = {}, nested = false)
			if nested
				params.each do |key, value|

					if value[:_destroy] == 'false'
						destroy_attribute = false
					else
						destroy_attribute = true
					end

					parent = value[:parent]
					parent_id = value[:parent_id]
					save_parent_values = value.clone
					id_array = []

					value.each do |key|
						name = key[0].split("_")
						if name.length.to_i == 3 && "#{name[0]}_#{name[1]}" == "image_temporal"
							id_array << name[2].to_s
						end
						id_array.each do |image_name|
							if key[0].match(image_name)
								save_parent_values.delete(key[0].to_sym)
							end
						end					
					end

					save_parent_values.delete(:parent)
					save_parent_values.delete(:parent_id)
					save_parent_values.delete(:id_images)
					save_parent_values.delete(:id)
					save_parent_values.delete(:_destroy)

					save_parent_values["#{object.class.name.underscore}_id"] = object.id
					parent_class = parent.constantize
					if parent_id == '' && destroy_attribute == false
						save_parent = parent_class.new(save_parent_values)
						if save_parent.save
							if id_array != []
								id_array.map { |image_name|  
									path = value["image_temporal_#{image_name}"]
									if path.to_s != "" && File.exist?(path.to_s)
										image = save_parent.crimagify_images.where("image_name=?", image_name)
										if image != []
											image.map { |img|  
												img.update_attributes(:image => File.open(path.to_s),
																							:crop_x => value["#{image_name}_crop_x"],
																							:crop_y => value["#{image_name}_crop_y"],
																							:crop_w => value["#{image_name}_crop_w"],
																							:crop_h => value["#{image_name}_crop_h"])
												img.crop_avatar_real
											}
										else
											img = save_new_image(path,
																					 value["#{image_name}_crop_x"],
																					 value["#{image_name}_crop_y"],
																					 value["#{image_name}_crop_w"],
																					 value["#{image_name}_crop_h"],
																					 save_parent.class.name,
																					 save_parent.id,
																					 image_name,
																					 false)
											img.save!
											img.crop_avatar_real
										end
									end
								}
							end						
						end
					else
						object_parent_image = parent_class.find(parent_id)
						if destroy_attribute
							object_parent_image.destroy
						else							
							if object_parent_image.update_attributes(save_parent_values)
								if id_array != []
									id_array.map { |image_name|  
										path = value["image_temporal_#{image_name}"]
										if path.to_s != "" && File.exist?(path.to_s)
											image = object_parent_image.crimagify_images.where("image_name=?", image_name)
											if image != []
												image.map { |img|  
													img.update_attributes(:image => File.open(path.to_s),
																								:crop_x => value["#{image_name}_crop_x"],
																								:crop_y => value["#{image_name}_crop_y"],
																								:crop_w => value["#{image_name}_crop_w"],
																								:crop_h => value["#{image_name}_crop_h"])
													img.crop_avatar_real
												}
											else
												img = save_new_image(path,
																						 value["#{image_name}_crop_x"],
																						 value["#{image_name}_crop_y"],
																						 value["#{image_name}_crop_w"],
																						 value["#{image_name}_crop_h"],
																						 object_parent_image.class.name,
																						 object_parent_image.id,
																						 image_name,
																						 false)
												img.save!
												img.crop_avatar_real
											end
										end
									}
								end						
							end
						end						
					end					
				end
			else
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
		end

		def create_new_images(object, params, nested = false)
			puts "esto trae params #{params}"
			if !params.nil?
				if nested
					params.each do |key, value|
						if value[:_destroy] == 'false'
							destroy_attribute = false
						else
							destroy_attribute = true
						end
						if !destroy_attribute
							parent = value[:parent]
							parent_id = value[:parent_id]
							save_parent_values = value.clone
							id_array = []

							value.each do |key|
								name = key[0].split("_")						
								if name.length.to_i == 3 && "#{name[0]}_#{name[1]}" == "image_temporal"
									id_array << name[2].to_s
								end
								id_array.each do |image_name|
									if key[0].match(image_name)
										save_parent_values.delete(key[0].to_sym)
									end
								end
							end
							save_parent_values.delete(:parent)
							save_parent_values.delete(:parent_id)
							save_parent_values.delete(:id_images)
							save_parent_values.delete(:id)
							save_parent_values.delete(:_destroy)


							save_parent_values["#{object.class.name.underscore}_id"] = object.id
							parent_class = parent.constantize
							save_parent = parent_class.new(save_parent_values)

							if save_parent.save
								id_array.map { |image_name| 
									path = value["image_temporal_#{image_name}"]

									if path.to_s != "" && File.exist?(path.to_s)
										img = save_new_image(path.to_s,
															 					 value["#{image_name}_crop_x"],
															 					 value["#{image_name}_crop_y"],
															 					 value["#{image_name}_crop_w"],
															 					 value["#{image_name}_crop_h"],
															 					 save_parent.class.name,
															 					 save_parent.id,
															 					 image_name,
															 					 false)
										img.save!
										img.crop_avatar_real
									end
								}
							end
						end											
					end				
				else
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
	end
end