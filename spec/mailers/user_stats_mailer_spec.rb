require "rails_helper"

RSpec.describe UserStatsMailer, type: :mailer do
  describe "summary_email" do
    let(:user) { create(:user, email: "test@example.com") }
    let(:mail) { UserStatsMailer.summary_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your CineRate stats is ready!")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "support@cinerate.com" ])
    end
  end
end
