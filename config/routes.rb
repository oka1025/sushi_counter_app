Rails.application.routes.draw do
  get 'bookmarks/create'
  get 'bookmarks/destroy'
  get 'gachas/show'
  get 'gachas/draw'
  root to: "homes#index"
  get "terms", to: "homes#terms"
  get "privacy", to: "homes#privacy"
  get "explanation", to: "homes#explanation" 
  get '/ping', to: 'health_check#ping'
  get 'email_change/confirm', to: 'users#confirm_email_change', as: :confirm_email_change
  post 'email_change/request', to: 'users#request_email_change', as: :request_email_change


  #get "/admin/normalize_kana", to: "admin#normalize_kana"

  resources :sushi_items, only: [:new, :create, :index, :edit, :destroy, :update] do
    member do
      patch :update_count
      delete :remove_image
    end
    resource :bookmark, only: [:create, :destroy]
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
    get 'public_result/:public_token', to: 'gachas#public_result', as: :public_result
  end

  delete "gachas/result", to: "gachas#destroy_session", as: :destroy_session

  resources :user_gacha_lists, only: [:index]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  get 'password_reset_done', to: 'homes#password_reset_done', as: :password_reset_done
  get 'email_change_done', to: 'homes#email_change_done', as: :email_change_done

  devise_scope :users do
    get '/users', to: redirect("/users/sign_up")
  end

  resource :user, only: [:show, :update, :edit] 

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
