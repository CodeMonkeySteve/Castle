namespace :db  do
  desc "Create the database for the current Rails.env"
  task :create => :environment  do |t|
    CouchRest::Model::Base.database.create!
  end

  desc "Drops the database for the current Rails.env"
  task :drop => :environment  do |t|
    CouchRest::Model::Base.database.delete!
  end

  desc "Load the seed data from db/seeds.rb"
  task :seed => :environment  do |t|
    require Rails.root+'db/seeds'
  end

  task :setup => [:create, :migrate, :seed]
  task :reseed => [:drop, :setup]

  desc "Update design documents on server"
  task :migrate => :environment  do |t|
    Dir[Rails.root+'app/models/*.rb'].map { |m|  require(m) }
    CouchRest::Model::Base.subclasses.each do |klass|
      klass.save_design_doc!  if klass.respond_to?(:save_design_doc!)
    end
  end
end