require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module I2X
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += %W(#{config.root}/app/workers)
    config.autoload_paths += %W(#{config.root}/app/helpers)
    config.autoload_paths += %W(#{config.root}/lib)

    Raven.configure do |config|
        config.dsn = 'http://f7613acf782045ed8d08a8e2262891d0:10bfbe80ae07446e8f07f100f7849f84@0.0.0.0:9000/1'
         config.environments = %w[ production development test ]
    end    
  end


end
