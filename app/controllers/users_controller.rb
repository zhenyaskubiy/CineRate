class UsersController < ApplicationController
  before_action :authenticate_user!
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_profile_path, notice: "Profile has been updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "User not found"
  end

  def rated_movies
    @user = User.find_by(id: params[:id])
    user_movies = @user.user_movies
                      .where(status: "watched")
                      .where.not(rating: nil)
                      .order(rating: :desc, updated_at: :desc)

    @rated_movies = user_movies.map do |um|
      media_data = TmdbService.fetch_media_details(um.tmdb_id, um.media_type || "movie")
      next if media_data.nil? || media_data.key?("error")

      {
        user_movie: um,
        title: media_data["title"] || media_data["name"] || "Unknown",
        poster: media_data["poster_path"],
        year: (media_data["release_date"] || media_data["first_air_date"])&.split("-")&.first
      }
    end.compact
  end
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :birth_date, :avatar)
  end
end
