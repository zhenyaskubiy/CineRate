class CalculateUserStatsJob
  include Sidekiq::Job

  def perform(user_id = nil, send_email = false)
    if user_id
      process_user(user_id, send_email)
    else
      User.find_each do |user|
        process_user(user.id, true)
      end
    end
  end

  private

  def process_user(user_id, send_email)
    user = User.find_by(id: user_id)
    return unless user

    total_minutes = user.user_movies
      .where(status: "watched")
      .sum(:runtime)

    return if total_minutes.zero? && send_email

    user.update_column(:total_watch_time, total_minutes)

    UserStatsMailer.summary_email(user).deliver_later if send_email
  end
end
