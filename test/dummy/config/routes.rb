Rails.application.routes.draw do

  resources :categories


  resources :products


  resources :users

  root :to => "users#index"

  mount Crimagify::Engine => "/crimagify", :as => "crimagify"
end
