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
      @img = {}
      @img[:parent_element_id] = params[:parent_element_id]
      @img[:data_parent] = ImageFunctions::get_data_parent(params[:parent], params[:parent_id]) #0
      if params[:parent_fieldset].blank?
        @img[:path_image] = ImageFunctions::write_tmp_image(params[:image], params[:parent_id].to_i, params[:parent], @img[:parent_element_id])
      else
        puts "yyyyyyyyy"
        @img[:parent_fieldset] = params[:parent_fieldset]
        @img[:path_image] = ImageFunctions::write_tmp_image(params[:image], params[:parent_id].to_i, params[:parent], @img[:parent_element_id], params[:parent_fieldset])
      end 
      @img[:crop_x] = params[:crop_x] #2
      @img[:crop_y] = params[:crop_y] #3
      @img[:crop_w] = params[:crop_w] #4
      @img[:crop_h] = params[:crop_h] #5
      @img[:parent] = params[:parent] #6
      if File.exist?(@img[:path_image])
        if @img[:data_parent] == 0
          @img_new = Crimagify::Image.find_by_parent_id(@img[:data_parent])
          @img_new.update_attributes(:image_temporal => File.open(@img[:path_image]),
                                     :crop_x =>  @img[:crop_x],
                                     :crop_y =>  @img[:crop_y],
                                     :crop_w =>  @img[:crop_w],
                                     :crop_h =>  @img[:crop_h])
          @img_new.crop_avatar_temporal
        else
          if @img[:data_parent].crimagify_images != []
            @cond = true
            @img[:data_parent].crimagify_images.map{ |image|
              if image.image_name == @img[:parent_element_id]
                image.update_attributes(:image_temporal => File.open(@img[:path_image]),
                                        :crop_x => params[:crop_x],
                                        :crop_y => params[:crop_y],
                                        :crop_w => params[:crop_w],
                                        :crop_h => params[:crop_h])
                image.crop_avatar_temporal
                @cond = false
              end
            }
            if @cond
              img = ImageFunctions::save_new_image(@img[:path_image], @img[:crop_x], @img[:crop_y], @img[:crop_w], @img[:crop_h], params[:parent], @img[:data_parent].id, @img[:parent_element_id], true)
              img.save!
              img.crop_avatar_temporal
              @img[:data_parent] = ImageFunctions::get_data_parent(params[:parent], params[:parent_id]) #0
            end
          else
            img = ImageFunctions::save_new_image(@img[:path_image], @img[:crop_x], @img[:crop_y], @img[:crop_w], @img[:crop_h], params[:parent], @img[:data_parent].id, @img[:parent_element_id], true)
            img.save!
            img.crop_avatar_temporal
            @img[:data_parent] = ImageFunctions::get_data_parent(params[:parent], params[:parent_id]) #0
          end
        end        
      else
        puts "No existe el directorio: #{@img[:path_image]}"
      end      
    end
  end
end