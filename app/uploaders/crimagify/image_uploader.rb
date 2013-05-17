# encoding: utf-8
module Crimagify
  class ImageUploader < CarrierWave::Uploader::Base

    # Include RMagick or MiniMagick support:
    include CarrierWave::RMagick
    # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
    # include Sprockets::Helpers::RailsHelper
    # include Sprockets::Helpers::IsolatedHelper


    # Choose what kind of storage to use for this uploader:
    storage :file
    # storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"      
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url
    #   # For Rails 3.1+ asset pipeline compatibility:
    #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    #
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end

    #==========================ThisAreaIsForSizeVersions==========================================================
    
    def self.enable_processing(value=nil)
      array_versions = []
      CRIMAGIFY_ENV.each do |image_name|
        image_name[1].each do |name|
          name_version = name[1]
          name_version.each do |item|
            array_versions << item.first
          end      
        end
      end
      return array_versions
    end 
    
    array_versions = enable_processing.uniq
    array_versions.each do |item|
      item = item.to_sym
      version item do
        process :crop
      end
    end

    ################ ORIGINAL  

    # version :aux_medium do
    #   process :crop
    #   resize_to_fit(158, 236)
    # end

    # version :aux_thumb do
    #   process :crop
    #   resize_to_fit(57, 85)
    # end


    # version :medium, :from_version => :aux_medium do
    #   process :crop_medium# => [158,236]
    #   resize_to_limit(158,161)
    # end

    # version :thumb, :from_version => :aux_thumb do
    #   process :crop_thumb
    #   resize_to_fit(57,59)
    # end

    ################ ORIGINAL

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def crop
      width = 0
      heigth = 0
      parent = model.parent_type
      image_name = model.image_name
      if parent == ""
        aux_name = original_filename.split("-")
        parent = aux_name[3].to_s
        image_name = aux_name[4].to_s
      end

      CRIMAGIFY_ENV["#{parent}"]["#{image_name}"].each do |size_name|
        if size_name.first == "#{version_name}"
          if model.crop_x.present?
            manipulate! do |img|
              x = model.crop_x.to_i
              y = model.crop_y.to_i
              w = model.crop_w.to_i
              h = model.crop_h.to_i
              img.crop!(x, y, w, h)
              
              width = CRIMAGIFY_ENV["#{parent}"]["#{image_name}"]["#{version_name}"]['width'].to_i
              height = CRIMAGIFY_ENV["#{parent}"]["#{image_name}"]["#{version_name}"]['height'].to_i
              img.resize_to_fit(width, height)
            end
          end
        end
      end
    end

    # def crop_medium#(width, height)
    #   manipulate! do |img|
    #     x = 0
    #     y = (236 - 161)/2
    #     img.crop!(x, y, 158, 161)
    #   end
    # end

    # def crop_thumb
    #   manipulate! do |img|
    #     x = 0
    #     y = (85 - 59)/2
    #     img.crop!(x, y, 57, 59)
    #   end    
    # end
  end
end