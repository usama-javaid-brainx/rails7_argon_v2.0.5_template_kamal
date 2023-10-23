DeviseTokenAuth.setup do |config|
  config.default_confirm_success_url = "/"
  config.enable_standard_devise_support = true
  config.token_lifespan = 2.years
  config.batch_request_buffer_throttle = 10.seconds
  config.change_headers_on_each_request = false
  config.max_number_of_devices = 1
  config.enable_standard_devise_support = true
  config.headers_names = { :'access-token' => 'access-token',
                           :'client' => 'client',
                           :'expiry' => 'expiry',
                           :'uid' => 'uid',
                           :'token-type' => 'token-type',
                           :authorization => 'authorization'
  }
end
