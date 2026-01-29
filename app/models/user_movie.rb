class UserMovie < ApplicationRecord
  belongs_to :user

  enum :status, { want_to_watch: 0, watched: 1, not_interested: 2 }

  validates :user_id, uniqueness: { scope: :tmdb_id }
  validates :tmdb_id, presence: true
end
