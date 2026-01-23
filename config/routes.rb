Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "about", to: "pages#about"
  get "trending", to: "pages#trending"

  # get "top_10", to: "pages#top_10"
  # get "what_to_watch", to: "pages#what_to_watch"
end
