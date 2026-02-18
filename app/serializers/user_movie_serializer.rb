class UserMovieSerializer
  include JSONAPI::Serializer
  attributes :tmdb_id, :status, :rating, :user_id
end
