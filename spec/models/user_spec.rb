require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, email: "jenya@example.com", password: "password123") }

  describe 'profile management' do
    describe '#full_name_upcase' do
      it 'returns uppercased email username when name is not set' do
        expect(user.full_name_upcase).to eq("JENYA")
      end
      it 'returns uppercased full name when set' do
        user.first_name = "Jenya"
        user.last_name = "Skubii"
        user.save(validate: false)

        expect(user.full_name_upcase).to eq("JENYA SKUBII")
      end
      it 'returns uppercased first name only when last name is not set' do
        user.first_name = "Jenya"
        user.save(validate: false)
        expect(user.full_name_upcase).to eq("JENYA")
      end
    end
    describe 'profile completion validations' do
      it 'requires first_name on update' do
        user.last_name = "Skubii"
        user.gender = "Female"
        user.birth_date = "2007-08-25"
        expect(user.valid?(:update)).to be false
        expect(user.errors[:first_name]).to include("can't be blank")
      end
      it 'requires last_name on update' do
        user.first_name = "Jenya"
        user.gender = "Female"
        user.birth_date = "2007-08-25"
        expect(user.valid?(:update)).to be false
        expect(user.errors[:last_name]).to include("can't be blank")
      end
      it 'requires gender on update' do
        user.first_name = "Jenya"
        user.last_name = "Skubii"
        user.birth_date = "2007-08-25"
        expect(user.valid?(:update)).to be false
        expect(user.errors[:gender]).to include("can't be blank")
      end
      it 'requires birth_date on update' do
        user.first_name = "Jenya"
        user.last_name = "Skubii"
        user.gender = "Female"
        expect(user.valid?(:update)).to be false
        expect(user.errors[:birth_date]).to include("can't be blank")
      end
      it 'validates first_name minimum length' do
        user.first_name = "J"
        user.last_name = "Skubii"
        user.gender = "Female"
        user.birth_date = "2007-08-25"
        expect(user.valid?(:update)).to be false
        expect(user.errors[:first_name]).to include("is too short (minimum is 2 characters)")
      end
      it 'allows valid profile update' do
        user.first_name = "Jenya"
        user.last_name = "Skubii"
        user.gender = "Female"
        user.birth_date = "2007-08-25"
        expect(user.valid?(:update)).to be true
        expect(user.save).to be true
      end
    end
    describe 'avatar attachment' do
      it 'attaches avatar successfully' do
        avatar_file = fixture_file_upload('avatar.jpeg', 'image/jpeg')
        user.avatar.attach(avatar_file)
        expect(user.avatar).to be_attached
        expect(user.avatar.filename.to_s).to eq('avatar.jpeg')
        expect(user.avatar.content_type).to eq('image/jpeg')
      end
    end
  end
  describe 'movie tracking' do
    describe '#watched_movies' do
      it 'counts watched movies correctly' do
        create(:user_movie, user: user, status: :watched)
        create(:user_movie, user: user, status: :watched)
        create(:user_movie, user: user, status: :want_to_watch)
        expect(user.watched_movies).to eq(2)
      end
      it 'returns zero when no movies watched' do
        expect(user.watched_movies).to eq(0)
      end
    end
    describe '#watchlist' do
      it 'counts want_to_watch movies correctly' do
        create(:user_movie, user: user, status: :want_to_watch)
        create(:user_movie, user: user, status: :want_to_watch)
        create(:user_movie, user: user, status: :watched)
        expect(user.watchlist).to eq(2)
      end
      it 'returns zero when watchlist is empty' do
        expect(user.watchlist).to eq(0)
      end
    end
    describe '#not_interested_movies' do
      it 'counts not_interested movies correctly' do
        create(:user_movie, user: user, status: :not_interested)
        create(:user_movie, user: user, status: :not_interested)
        create(:user_movie, user: user, status: :watched)
        expect(user.not_interested_movies).to eq(2)
      end
    end
  end
  describe 'watch time statistics' do
    it 'calculates total watch time from watched movies' do
      create(:user_movie, user: user, status: :watched, runtime: 120)
      create(:user_movie, user: user, status: :watched, runtime: 90)
      create(:user_movie, user: user, status: :want_to_watch, runtime: 60)
      total = user.user_movies.where(status: 'watched').sum(:runtime)
      expect(total).to eq(210)
    end
    it 'updates total_watch_time without triggering validations' do
      create(:user_movie, user: user, status: :watched, runtime: 120)
      user.update_column(:total_watch_time, 120)
      expect(user.reload.total_watch_time).to eq(120)
    end
    it 'tracks watch time in hours' do
      user.update_column(:total_watch_time, 180)
      expect(user.total_watch_time / 60.0).to eq(3.0)
    end
  end
  describe 'full profile lifecycle' do
    it 'handles complete user journey' do
      expect(user.full_name_upcase).to eq("JENYA")
      user.update!(
        first_name: "Jenya",
        last_name: "Skubii",
        gender: "Female",
        birth_date: "2007-08-25"
      )
      avatar_file = fixture_file_upload('avatar.jpeg', 'image/jpeg')
      user.avatar.attach(avatar_file)
      expect(user.avatar).to be_attached
      create(:user_movie, user: user, status: :watched, runtime: 120)
      create(:user_movie, user: user, status: :want_to_watch)
      expect(user.watched_movies).to eq(1)
      expect(user.watchlist).to eq(1)
      expect(user.full_name_upcase).to eq("JENYA SKUBII")
      expect(user.gender).to eq("Female")
    end
  end
end
