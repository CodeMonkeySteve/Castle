CouchRest::Model::Base.configure do |conf|
  conf.connection[:join] = '-'
end

