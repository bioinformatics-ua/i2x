require 'raven'
require 'rails_config'

module Services
	class Slog
		
		public
		##
		# => Log Exceptions to Sentry using Raven
		#
		def self.exception exception
			begin
				if Settings.log.sentry then
					Raven.capture_exception(exception)
				else
					puts exception.inspect
				end
				
			rescue Exception => e
				if Settings.log.sentry then
					Raven.capture_exception(e)
				else
					puts e.inspect
				end
			end
		end
		
		##
		# => Log information messages to Sentry using Raven
		#
		def self.info message
			begin
				message[:l] = 'info'
				if Settings.log.sentry then
					capture_message message
				end
			rescue Exception => e
				exception e
			end

		end
		
		##
		# => Log debug messages to Sentry using Raven
		#
		def self.debug message
			begin
				if Settings.app.debug then
					message[:l] = 'debug'
					if Settings.log.sentry then
						capture_message message
					end
				end
			rescue Exception => e
				exception e
			end
		end

		##
		# => Log warning messages to Sentry using Raven
		#
		def self.warn message
			begin
				if Settings.app.debug then
					message[:l] = 'warn'
					if Settings.log.sentry then
						capture_message message
					end
				end
			rescue Exception => e
				exception e
			end
		end
		
		
		private
		
		##
		# => Generic message capture
		#
		def self.capture_message message
			begin
			Raven.capture_message("#{message[:message]}", {
																:level => message[:l],
																:tags => {
																	'environment' => Rails.env,
																	'version' => Settings.app.version,
																	'module' => message[:module],
																	'task' => message[:task]
																},
																:server_name => Settings.app.host,
																:extra => message[:extra]
				})
			rescue Exception => e
				exception e
			end
		end
	end
end