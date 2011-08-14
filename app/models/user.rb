class User < CouchRest::Model::Base
  property :openid_url
  property :name

  validates_presence_of :openid_url

  design do
    view :by_openid_url
  end
end