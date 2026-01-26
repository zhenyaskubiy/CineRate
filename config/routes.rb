Rails.application.routes.draw do
  devise_for :users

  root "movies#index"

  get "about", to: "pages#about"
  get "trending", to: "movies#index"
  get "media", to: "pages#media"
end
