class UserStatsMailer < ActionMailer::Base
  default from: "support@cinerate.com"
  def summary_email(user)
    @user = user
    mail(to: @user.email, subject: "Your CineRate stats is ready!")
  end
end
