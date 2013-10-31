require 'delayed_job'
require 'csv'

module Services
	class Checkup
		def check			
			dt = Time.new
    		File.open('data/log.csv', 'a') { |file| file.write("#{dt.to_time}\n") }
		end
  		handle_asynchronously :check		
	end
end