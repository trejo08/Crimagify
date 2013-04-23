class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @images = Crimagify::Image.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @error = true
    id_array = params[:id_images].split(",")

    respond_to do |format|
      if @user.save
        id_array.map { |image_name|  
          path = params["image_temporal_#{image_name}"]
          if !(path.to_s == "") && File.exist?(path.to_s)
            img = Crimagify::ImageFunctions::save_new_image(path.to_s, 
                                               params["#{image_name}_crop_x"], 
                                               params["#{image_name}_crop_y"], 
                                               params["#{image_name}_crop_w"], 
                                               params["#{image_name}_crop_h"], 
                                               params[:parent], 
                                               @user.id, 
                                               image_name, 
                                               false)
            img.save!
            img.crop_avatar_real          
          end
          @error = false
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    id_array = params[:id_images].split(",")

    id_array.map { |image_name|
      path = params["image_temporal_#{image_name}"]
      if !(path.to_s == "") && File.exist?(path.to_s)
        image = @user.crimagify_images.where("image_name=?",image_name)
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
          img = Crimagify::ImageFunctions::save_new_image(path.to_s, 
                                               params["#{image_name}_crop_x"], 
                                               params["#{image_name}_crop_y"], 
                                               params["#{image_name}_crop_w"], 
                                               params["#{image_name}_crop_h"], 
                                               params[:parent], 
                                               @user.id, 
                                               image_name, 
                                               false)
          img.save!
          img.crop_avatar_real
        end
      end
    }
    respond_to do |format|
      # if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      # end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
