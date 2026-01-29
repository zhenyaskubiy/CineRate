Rails.application.routes.draw do
  devise_for :users

  root "pages#media"

  get "about", to: "pages#about"
  get "trending", to: "movies#index"
  get "media", to: "pages#media"

  resources :user_movies, only: [ :create ]
end
