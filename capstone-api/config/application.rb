require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CapstoneApi
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.x.GCM_KEY = "AIzaSyDgEwlJvSX1Jew18m90u4K-ijIoXQHmkss"
  end
end
