class CalculateUserStatsJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    total_minutes = user.user_movies
                        .where(status: "watched")
                        .sum(:runtime)

    user.update!(total_watch_time: total_minutes)

    UserStatsMailer.summary_email(user).deliver_now
  end
end
