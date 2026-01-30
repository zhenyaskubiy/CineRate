class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_movies, dependent: :destroy
  has_one_attached :avatar

  def watchlist
    user_movies.want_to_watch
  end

  def watched_movies
    user_movies.watched
  end

  def not_interested_movies
    user_movies.not_interested
  end

  def full_name_upcase
    "#{first_name} #{last_name}".upcase.strip
  rescue
    email.split("@").first.upcase
  end

  GENDERS = [ "Male", "Female" ]
  validates :first_name, presence: true, length: { minimum: 2 }, on: :update
  validates :last_name, presence: true, length: { minimum: 2 }, on: :update
  validates :gender, presence: true, on: :update
  validates :birth_date, presence: true, on: :update
end
