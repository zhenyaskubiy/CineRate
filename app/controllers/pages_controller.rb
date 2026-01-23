class PagesController < ApplicationController
  def home
  end

  def about
  end

  def trending
    @movies = TmdbService.popular_movies
    if @movies.is_a?(Hash) && @movies.key?("error")
      @error = @movies["error"]
      @movies = []
    end
  end
end
