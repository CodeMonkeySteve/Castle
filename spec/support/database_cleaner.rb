class RSpec::Core::ExampleGroup
  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before do
      DatabaseCleaner.clean
    end
  end
end
