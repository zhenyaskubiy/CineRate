class UserMoviesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_movie = current_user.user_movies.find_or_initialize_by(tmdb_id: params[:tmdb_id])

    if @user_movie.status == params[:status]
      @user_movie.destroy
      msg = "Removed from list"
    else
      @user_movie.status = params[:status]
      @user_movie.media_type = params[:media_type] || "movie"

      if @user_movie.status == "watched"
        if params[:media_type] == "tv"
          media_data = TmdbService.fetch_tv_details(params[:tmdb_id])
        else
          media_data = TmdbService.fetch_movie_details(params[:tmdb_id])
        end
        @user_movie.runtime = media_data["runtime"] if media_data
      end

      if @user_movie.save
        msg = "Status updated to #{params[:status].humanize}"
      else
        msg = "Something went wrong"
      end
    end

    if @user_movie.destroyed? || @user_movie.saved_change_to_status?
      CalculateUserStatsJob.perform_async(current_user.id, false)
    end

    redirect_back fallback_location: root_path, notice: msg
  end

  def update_rating
    @user_movie = current_user.user_movies.find_by(tmdb_id: params[:tmdb_id])
    if @user_movie && @user_movie.status == "watched"
      if @user_movie.update(rating: params[:rating])
        msg = "Rating updated to #{params[:rating]} stars"
      else
        msg = "Invalid rating"
      end
    else
      msg = "Movie must be marked as watched to rate"
    end
    redirect_back fallback_location: root_path, notice: msg
  end
end
