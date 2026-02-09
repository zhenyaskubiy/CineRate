# Preview all emails at http://localhost:3000/rails/mailers/user_stats_mailer
class UserStatsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_stats_mailer/summary_email
  def summary_email
    UserStatsMailer.summary_email
  end

end
