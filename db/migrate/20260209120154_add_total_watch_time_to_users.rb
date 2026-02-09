class AddTotalWatchTimeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :total_watch_time, :integer, default: 0
  end
end
