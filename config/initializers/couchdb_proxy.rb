require 'rack/http_proxy'

Rails.application.config.middleware.insert_before 0, Rack::HttpProxy  do |req|
  if req.fullpath =~ %r{^/db(.*)$}
    URI.parse "http://localhost:5984#{$1}"
  end
end
