require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# require_relative "profiler"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :webmock 
end

module Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.log_level = :debug
    config.log_tags  = [:subdomain, :uuid]
    config.logger    = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    # config.middleware.use Profiler   

    config.autoload_paths << Rails.root.join('app/graph/mutations')
    config.autoload_paths << Rails.root.join('app/graph/types')
    config.autoload_paths << Rails.root.join('app/graph/')
    #config.autoload_paths << Rails.root.join('app/lib/')
    config.eager_load_paths << Rails.root.join('app/lib')

    config.active_record.dump_schema_after_migration = false
    config.generators do |g|
      g.orm :active_record
    end
    config.middleware.insert_before 0, Rack::Cors do 
      allow do 
        origins '*' 
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end 
    end 
    config.api_only = true
 
  end
end
