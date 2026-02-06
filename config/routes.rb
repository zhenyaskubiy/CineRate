Rails.application.routes.draw do
  devise_for :users
  root "media#index"

  resources :media, only: [ :index ]
  get "media/:type/:id", to: "media#show", as: :media_item

  get "about", to: "pages#about"
  resource :profile, only: [ :edit, :update ], controller: "users"
  resources :users, only: [ :show ]
  resources :user_movies, only: [ :create ]
  get "trending", to: "movies#index"
end
