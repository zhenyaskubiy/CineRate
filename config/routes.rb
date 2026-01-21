Rails.application.routes.draw do
  root "pages#home"
  get "about", to: "pages#about"

  # get "top_10", to: "pages#top_10"
  # get "trending", to: "pages#trending"
  # get "what_to_watch", to: "pages#what_to_watch"
end
