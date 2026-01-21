Rails.application.routes.draw do
  get "pages/home"
  get "up" => "rails/health#show", as: :rails_health_check
  root "pages#home"

  # get "top_10", to: "pages#top_10"
  # get "trending", to: "pages#trending"
  # get "what_to_watch", to: "pages#what_to_watch"
end
