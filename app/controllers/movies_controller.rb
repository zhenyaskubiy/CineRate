class MoviesController < ApplicationController
  def index
    @movies = TmdbService.popular_movies
    if @movies.is_a?(Hash) && @movies.key?("error")
      @error = @movies["error"]
      @movies = []
    else
      @movies = @movies.first(20)
    end
  end
end
