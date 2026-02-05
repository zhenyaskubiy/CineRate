require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(email: "jenya@example.com", password: "password123") }

  it "перевіряє повний цикл профілю" do
    expect(user.full_name_upcase).to eq("JENYA")

    user.update!(
      first_name: "Jenya",
      last_name: "Skubii",
      gender: "Female",
      birth_date: "2007-08-25"
    )

    user.user_movies.create!(status: :watched, tmdb_id: 123)
    user.user_movies.create!(status: :want_to_watch, tmdb_id: 456)

    expect(user.watched_movies).to eq(1)
    expect(user.watchlist).to eq(1)
  end

  it "не дозволяє оновити профіль без статі або дати народження" do
    user.first_name = "Jenya"
    expect(user.valid?(:update)).to be false
  end
end
