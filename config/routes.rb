Rails.application.routes.draw do
  root to: "home#index"
  resources :sushi_items, only: [:new, :create, :index, :edit, :destroy, :update] do
    member do
      patch :update_count
    end
  end

  resources :counters, only: %i[index] 
    

  devise_for :users
  devise_scope :users do
    get '/users', to: redirect("/users/sign_up")
  end

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
