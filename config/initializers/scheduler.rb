require 'rubygems'
require 'rufus/scheduler'
require 'checkup'
require 'slog'
require 'json'

Thread.new {
  begin
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.connection.verify!(0)
    end
    Services::Checkup.new.boot
  rescue Exception => e
    Services::Slog.exception e
  ensure  
    ActiveRecord::Base.connection_pool.release_connection
  end
}

scheduler = Rufus::Scheduler.new

JSON.parse(ENV["APP_SCHEDULE"]).each do |timing|
  timing.each do |schedule,full|
    unless schedule == 'none' || schedule == 'remote'
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
  end
end