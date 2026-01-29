class UserMoviesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_movie = current_user.user_movies.find_or_initialize_by(tmdb_id: params[:tmdb_id])

    if @user_movie.status == params[:status]
      @user_movie.destroy
      msg = "Removed from list"
    else
      @user_movie.status = params[:status]
      @user_movie.save
      msg = "Status updated to #{params[:status].humanize}"
    end

    redirect_back fallback_location: root_path, notice: msg
  end
end
