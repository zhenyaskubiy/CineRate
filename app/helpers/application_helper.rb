module ApplicationHelper
  def display_watch_time(total_minutes)
    return "0 min" if total_minutes.blank? || total_minutes.zero?

    days = total_minutes / 1440
    hours = (total_minutes % 1440) / 60
    mins = total_minutes % 60

    parts = []
    parts << "#{days}d" if days > 0
    parts << "#{hours}h" if hours > 0
    parts << "#{mins}m" if mins > 0 || parts.empty?

    parts.join(" ")
  end
end
