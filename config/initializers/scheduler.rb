require 'rubygems'
require 'rufus/scheduler'
require 'checkup'
require 'slog'

# Thread.new {
#   begin
#     unless ActiveRecord::Base.connected?
#       ActiveRecord::Base.connection.verify!(0)
#     end
#     Services::Checkup.new.boot
#   rescue Exception => e
#     Services::Slog.exception e
#   ensure  
#     ActiveRecord::Base.connection_pool.release_connection
#   end
# }

scheduler = Rufus::Scheduler.new

if Rails.env.production? then
  timings = %w[5m 10m 30m 1h 2h 5h 12h 1d 2d 7d]
else
  timings = %w[5m 10m 30m 1h 2h 5h 12h 1d 2d 7d]
end


timings.each do |schedule|
  scheduler.every schedule do
    begin
      unless ActiveRecord::Base.connected?
        ActiveRecord::Base.connection.verify!(0)
      end
      Services::Checkup.new.check(schedule)
    rescue Exception => e
      Services::Slog.exception e
    ensure
      ActiveRecord::Base.connection_pool.release_connection
    end
  end
end