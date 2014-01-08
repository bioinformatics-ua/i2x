##
# => Only starts Raven/Sentry if it is available
#
if ENV["LOG_SENTRY"] then
	Raven.configure do |config|
		config.dsn = ENV["LOG_DSN"]
		config.environments = %w[ production development test ]
	end
end