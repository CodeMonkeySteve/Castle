module AuthenticationTestHelpers
  def sign_in(user)
    controller.send(:sign_in, user)
  end

  def sign_out(*args)
    controller.send(:sign_in, nil)
  end
end

RSpec.configure do |config|
  config.include AuthenticationTestHelpers
end
