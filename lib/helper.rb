module Services
	class Helper
		def self.hostname
			Rails.configuration.host
		end

		def self.datetime
			Time.now
		end

		def self.date
			Time.now.strftime("%Y-%m-%d")			
		end
	end
end
