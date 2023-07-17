require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Beautycosmetics
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    ActiveStorage::Current.url_options = Rails.application.routes.default_url_options
    config.after_initialize do
      Rails.application.routes.default_url_options = {
        host: 'localhost', # Cambia 'localhost' por el host de tu aplicación en producción
        port: 3000, # Cambia 3000 por el puerto en el que se está ejecutando tu aplicación en producción
        protocol: 'http' # Cambia 'http' a 'https' si estás usando SSL/TLS en producción
      }
    end
  end
end
