Rails.application.routes.draw do

  devise_for :users

  root to: "home#index"

  devise_scope :users do
    get '/users', to: redirect("/users/sign_up")
  end

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
