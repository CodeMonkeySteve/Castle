module CouchPotato
  def self.couchrest_database
    CouchRest::Model::Base.database
  end
end

class RSpec::Core::ExampleGroup
  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.orm = :couch_potato
      DatabaseCleaner.strategy = :truncation
    end
    config.before do
      DatabaseCleaner.clean
    end
  end
end
