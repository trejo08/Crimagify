include Crimagify::ImageFunctions
module Crimagify
  class CropperController < ApplicationController
  	#================================================================CropperAjaxActions================================================================#
    def partial_cropper
      @params = {
        :image => params[:image],
        :parent_element_id => params[:parent_element_id]
      }
    end

    def partial_nested_cropper
      @params = {
        :image => params[:image],
        :parent_element_id => params[:parent_element_id],
        :type_img => params[:type_img]
      }
    end

    def params_cropper
      @parent_element_id = params[:parent_element_id]
      @img = []
      @img << ImageFunctions::get_data_parent(params[:parent], params[:parent_id]) #0
      @image_generated = ImageFunctions::write_tmp_image(params[:image], params[:parent_id].to_i, params[:parent], @parent_element_id)
      @img << @image_generated #1
      @img << params[:crop_x] #2
      @img << params[:crop_y] #3
      @img << params[:crop_w] #4
      @img << params[:crop_h] #5
      @img << params[:parent] #6
      @img << params[:parent_element_id] #7

      if File.exist?(@image_generated)
        if @img[0] == 0
          @img_new = Crimagify::Image.find_by_parent_id(@img[0])
          @img_new.update_attributes(:image_temporal => File.open(@image_generated),
                                     :crop_x => params[:crop_x],
                                     :crop_y => params[:crop_y],
                                     :crop_w => params[:crop_w],
                                     :crop_h => params[:crop_h])
          @img_new.crop_avatar_temporal
        else
          if @img[0].crimagify_images != []
            @cond = true
            @img[0].crimagify_images.map{ |image|
              if image.image_name == @parent_element_id
                image.update_attributes(:image_temporal => File.open(@image_generated),
                                        :crop_x => params[:crop_x],
                                        :crop_y => params[:crop_y],
                                        :crop_w => params[:crop_w],
                                        :crop_h => params[:crop_h])
                image.crop_avatar_temporal
                @cond = false
              end
            }
            if @cond
              img = ImageFunctions::save_new_image(@image_generated, params[:crop_x], params[:crop_y], params[:crop_w], params[:crop_h], params[:parent], @img[0].id, @parent_element_id, true)
              img.save!
              img.crop_avatar_temporal
              @img[0] = ImageFunctions::get_data_parent(params[:parent], params[:parent_id]) #0
            end
          else
            img = ImageFunctions::save_new_image(@image_generated, params[:crop_x], params[:crop_y], params[:crop_w], params[:crop_h], params[:parent], @img[0].id, @parent_element_id, true)
            img.save!
            img.crop_avatar_temporal
            @img[0] = ImageFunctions::get_data_parent(params[:parent], params[:parent_id]) #0
          end
        end        
      else
        puts "No existe el directorio: #{@image_generated}"
      end      
    end

    def params_nested_cropper
      
    end
  end
end