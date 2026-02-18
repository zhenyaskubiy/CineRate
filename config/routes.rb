Rails.application.routes.draw do
  devise_for :users
  root "media#index"

  resources :media, only: [ :index ]
  get "media/:type/:id", to: "media#show", as: :media_item

  resource :profile, only: [ :edit, :update ], controller: "users"
    resources :users, only: [ :show ] do
      member do
        get :rated_movies
        get :watchlist
        get :ignored
      end
    end

  resources :user_movies, only: [ :create ] do
    patch :update_rating, on: :collection
  end
  get "trending", to: "movies#index"
  get "on-the-air", to: "pages#on_the_air"
  get "about", to: "pages#about"

  namespace :api do
    resources :user_movies
  end
end
