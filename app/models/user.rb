class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_movies, dependent: :destroy

  def watchlist
    user_movies.want_to_watch
  end

  def watched_movies
    user_movies.watched
  end

  def not_interested_movies
    user_movies.not_interested
  end
end
