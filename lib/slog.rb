require 'raven'


module Services
	class Slog
		
		public
		##
		# => Log Exceptions to Sentry using Raven
		#
		def self.exception exception
			begin
				if ENV["LOG_SENTRY"] then
					Raven.capture_exception(exception)
				else
					puts exception.inspect
				end
				
			rescue Exception => e
				if ENV["LOG_SENTRY"] then
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
				if ENV["LOG_SENTRY"] then
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
				if ENV["APP_DEBUG"] then
					message[:l] = 'debug'
					if ENV["LOG_SENTRY"] then
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
				if ENV["APP_DEBUG"] then
					message[:l] = 'warn'
					if ENV["LOG_SENTRY"] then
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
						'version' => ENV["APP_VERSION"],
						'module' => message[:module],
						'task' => message[:task]
						},
						:server_name => ENV["APP_HOST"],
						:extra => message[:extra]
						})
			rescue Exception => e
				exception e
			end
		end
	end
end