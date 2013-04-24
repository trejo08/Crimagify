Rails.application.routes.draw do

  resources :products


  resources :users

  root :to => "users#index"

  mount Crimagify::Engine => "/crimagify", :as => "crimagify"
end
