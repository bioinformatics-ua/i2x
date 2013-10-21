module Services
	
	##
	# = Detector
	#
	# Main change detection class, to be inherited by SQL, File and URL detectors
	#
	class Detector
		attr_accessor :identifier, :publisher, :agent

		def initialize identifier
			begin
				@agent = Agent.find_by! identifier: identifier
			rescue Exception => e
				
			end
		end
	end
end