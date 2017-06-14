require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Saudade
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.test_framework :rspec
    end

    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.assets.paths << Rails.root.join('node_modules')
    config.autoload_paths << Rails.root.join('lib')
  end
end
