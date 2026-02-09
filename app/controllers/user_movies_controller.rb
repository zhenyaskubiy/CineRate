class UserMoviesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_movie = current_user.user_movies.find_or_initialize_by(tmdb_id: params[:tmdb_id])

    if @user_movie.status == params[:status]
      @user_movie.destroy
      msg = "Removed from list"
    else
      @user_movie.status = params[:status]

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
      CalculateUserStatsJob.perform_async(current_user.id)
    end


    redirect_back fallback_location: root_path, notice: msg
  end
end
