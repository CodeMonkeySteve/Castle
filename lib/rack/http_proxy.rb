# Example Usage:
#
# use Rack::Proxy do |req|
#   if req.path =~ %r{^/remote/service.php$}
#     URI.parse("http://remote-service-provider.com/service-end-point.php?#{req.query}")
#   end
# end
#
# run proc{|env| [200, {"Content-Type" => "text/plain"}, ["Ha ha ha"]] }
#

class DeferrableBody
  include EventMachine::Deferrable

  def call(*body)
    body.each do |chunk|
      @body_callback.call(chunk)
    end
  end

  def each(&blk)
    @body_callback = blk
  end
end

class Rack::HttpProxy
  def initialize(app, &block)
    self.class.send(:define_method, :uri_for, &block)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    method = req.request_method.downcase.to_sym

    return @app.call(env) unless uri = uri_for(req)
puts uri

    opts = {}
    head = opts[:head] = {}

    if (body = req.body.read).present?
      opts[:body] = body
      opts[:head]['content-type'] = req.content_type
    end

    head['X-Forwarded-For'] = (req.env['X-Forwarded-For'].to_s.split(/, +/) + [req.env['REMOTE_ADDR']]).join(', ')
    head['X-Requested-With'] = req.env['HTTP_X_REQUESTED_WITH']  if req.env['HTTP_X_REQUESTED_WITH']
    head['Accept-Encoding'] = req.accept_encoding  if req.accept_encoding.present?
    head['Referer'] = req.referer  if req.referer.present?
    head.basic_auth *uri.userinfo.split(':') if (uri.userinfo && uri.userinfo.index(':'))

    body = DeferrableBody.new
    http = EventMachine::HttpRequest.new(uri).send("a#{method}", opts)
    http.headers do |headers|
      headers = headers.reject { |h|  %w(cookie content_length transfer_encoding).include?(h.downcase) }
      env['async.callback'].call([http.response_header.status, headers, body])
    end
    http.stream do |chunk|
      body.call(chunk)  unless chunk.empty?
    end
    http.callback { body.succeed }
    http.errback do
      # FIX ME
    end

    throw :async
  end
end
