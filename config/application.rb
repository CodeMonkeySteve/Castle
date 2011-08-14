$: << File.dirname(__FILE__)+'/../lib'
require File.expand_path('../boot', __FILE__)

require 'rails'
Bundler.require(:default, Rails.env)
Bundler.require *Rails.groups(:assets)
if Rails.env == 'development'
  Bundler.require( 'development_' + /darwin|linux|win32/.match(RUBY_PLATFORM)[0] )
end

require 'player'

module Castle
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.app_generators do |g|
      #g.orm :mongoid
      g.template_engine :haml
      g.stylesheet_engine :sass

      g.integration_tool :rspec
      g.test_framework :rspec, :fixture => true, :views => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    # CouchDB
    CouchRest::Model::Base.configure do |conf|
      conf.connection[:join] = '-'
    end

    # Asset pipeline
    config.assets.enabled = true
    config.assets.precompile = %w(all.js all.css)
    unless Rails.env.production?
      jss = Rails.root+'spec/javascripts'
      config.assets.paths += [jss+'support',jss].map(&:to_s)
      config.assets.precompile << 'test.js'
    end

    # OpenID
    config.middleware.insert_after ActionDispatch::Session::CookieStore, Rack::OpenID #, OpenidMongodbStore::Store.new

    # Rack fiber pool
    config.middleware.insert_before 0, Rack::FiberPool
    config.threadsafe!
  end

  def self.player
    @player ||= Player.new
  end
end
