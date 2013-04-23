module Crimagify
	module ImageFunctions

		def write_tmp_image(image, parent_id, parent_type, image_name)
		    require 'base64'
		    image_encoded = image.split(",")      
		    extension = image_encoded[0].split("/")[1].split(";")[0]

		    today = Time.now
		    generate_name = "#{today.strftime("%Y-%m-%d")}-#{parent_type}-#{image_name}-#{parent_id}"

		    path = "#{Rails.root}/app/assets/images/tmps_cropper/#{parent_type}/image_temporal/#{parent_id}/#{image_name}"

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
	end
end