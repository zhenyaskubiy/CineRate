module Api
  class UserMoviesController < Api::ApplicationController
    def index
      user_movies = ::UserMovie.all
      render json: UserMovieSerializer.new(user_movies).serializable_hash
    end
  end
end
