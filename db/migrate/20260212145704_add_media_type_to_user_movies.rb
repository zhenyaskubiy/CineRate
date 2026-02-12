class AddMediaTypeToUserMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :user_movies, :media_type, :string
  end
end
