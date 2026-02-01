require 'sidekiq/web'

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      post 'signup', to: 'users#create'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      get 'me', to: 'users#show'

      resources :bookmarks, only: [:index, :show, :create, :destroy]
    end
  end
end
