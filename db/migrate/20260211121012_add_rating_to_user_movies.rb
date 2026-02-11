class AddRatingToUserMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :user_movies, :rating, :integer
  end
end
