ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :rr
  def config.fixture_path()  @fixture_path ||= Rails.root+'spec/fixtures'  end

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  config.include AudioFixtures
end

# clear screen
print "\x1b[2J\x1b[H" ; $stdout.flush
