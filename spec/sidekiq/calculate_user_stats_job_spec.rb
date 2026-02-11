require 'rails_helper'

RSpec.describe CalculateUserStatsJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }

    context 'with single user and no email' do
      it 'calculates total watch time' do
        create(:user_movie, user: user, status: 'watched', runtime: 120)
        create(:user_movie, user: user, status: 'watched', runtime: 90)

        expect {
          described_class.new.perform(user.id, false)
        }.to change { user.reload.total_watch_time }.to(210)
      end

      it 'does not send email' do
        create(:user_movie, user: user, status: 'watched', runtime: 120)

        expect(UserStatsMailer).not_to receive(:summary_email)

        described_class.new.perform(user.id, false)
      end
    end

    context 'with single user and email enabled' do
      it 'sends email when user has watched movies' do
        create(:user_movie, user: user, status: 'watched', runtime: 120)

        expect {
          described_class.new.perform(user.id, true)
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end

      it 'skips email when user has no watched movies' do
        expect(UserStatsMailer).not_to receive(:summary_email)

        described_class.new.perform(user.id, true)
      end
    end

    context 'batch processing all users' do
      it 'processes multiple users and sends emails' do
        user2 = create(:user)
        create(:user_movie, user: user, status: 'watched', runtime: 120)
        create(:user_movie, user: user2, status: 'watched', runtime: 90)
        # rubocop:disable Layout/TrailingWhitespace
        expect {
          described_class.new.perform(nil, true)
        }.to change { user.reload.total_watch_time }.to(120)
          .and change { user2.reload.total_watch_time }.to(90)
      end
      
      it 'sends emails to all users with watched movies' do
        user2 = create(:user)
        create(:user_movie, user: user, status: 'watched', runtime: 120)
        create(:user_movie, user: user2, status: 'watched', runtime: 90)
        
        expect {
          described_class.new.perform(nil, true)
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob).at_least(2).times
      end
    end
  end
end
