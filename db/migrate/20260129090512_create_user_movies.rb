class CreateUserMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :user_movies do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :tmdb_id
      t.integer :status

      t.timestamps
    end
  end
end
