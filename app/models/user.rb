class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_movies, dependent: :destroy
  has_one_attached :avatar

  def watchlist
    user_movies.want_to_watch.count
  end

  def watched_movies
    user_movies.watched.count
  end

  def not_interested_movies
    user_movies.not_interested.count
  end

  def full_name_upcase
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip.upcase
    else
      email.to_s.split("@").first.to_s.upcase
    end
  end

  GENDERS = [ "Male", "Female" ]
  validates :first_name, presence: true, length: { minimum: 2 }, on: :update
  validates :last_name, presence: true, length: { minimum: 2 }, on: :update
  validates :gender, presence: true, on: :update
  validates :birth_date, presence: true, on: :update
end
