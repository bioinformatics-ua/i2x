module Services
	class Helper
		attr_accessor :replacements	
		@replacements

		def initialize
			# load each helper function into a map for replacement in the delivery
			@replacements = [ ["%{i2x.date}", self.date], ["%{i2x.datetime}", self.datetime], ["%{i2x.hostname}", self.hostname]]			
		end

		public
		def hostname
			Rails.configuration.host
		end

		def datetime
			Time.now.to_s
		end

		def date
			Time.now.strftime("%Y-%m-%d").to_s			
		end
	end
end
