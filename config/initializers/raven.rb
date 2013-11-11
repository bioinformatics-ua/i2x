require 'rails_config'

##
# => Only starts Raven/Sentry if it is available
#
if Settings.log.sentry then
  Raven.configure do |config|
    config.dsn = Settings.log.dsn
    config.environments = %w[ production development test ]
  end
end