Crimagify::Engine.routes.draw do
	post "partial_cropper", :to => "cropper#partial_cropper"#, :as => :partial_cropper
  post "params_cropper", :to => "cropper#params_cropper", :as => :params_cropper
end
