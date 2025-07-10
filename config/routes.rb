Rails.application.routes.draw do
  get 'gachas/show'
  get 'gachas/draw'
  root to: "homes#index"
  get "terms", to: "homes#terms"
  get "privacy", to: "homes#privacy"
  #get "/admin/normalize_kana", to: "admin#normalize_kana"

  resources :sushi_items, only: [:new, :create, :index, :edit, :destroy, :update] do
    member do
      patch :update_count
      delete :remove_image
    end
  end

  resources :counters, only: [:new, :update, :index, :show, :edit, :destroy] do
    member do
      delete :reset_items
      post :use
    end
    collection do
      get :summary
      get :autocomplete_store_name
      get :autocomplete_sushi_name
    end
  end

  resource :gachas, only: [:show] do
    post :draw, on: :collection
    get :result
  end

  delete "gachas/result", to: "gachas#destroy_session", as: :destroy_session

  resources :user_gacha_lists, only: [:index]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :users do
    get '/users', to: redirect("/users/sign_up")
  end

  resource :user, only: [:show, :update]

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
