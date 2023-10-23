Apipie.configure do |config|
  config.app_name = "Goal Management System"
  config.copyright = "&copy; #{Time.zone.now.year} BrainX Technologies"
  config.api_base_url = "/api/v1/"
  config.doc_base_url = "/api_docs"
  # where is your API defined?
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "api", "**", "*.rb")

  config.translate = false
  config.validate = false

  config.app_info["1.0"] = "
    In Header these params required for authentication
      authorization: Bearer token
      content-type: '	application/json',

    Default Error format.
      {
          'error': 'Error Message'
      }

     Default Success format.
      {
          'message': 'Error Message'
      }
  "
  config.authenticate = proc do
    authenticate_or_request_with_http_basic do |username, password|
      Rails.env.development? || username == "developer" && password == "password"
    end
  end
  # access-token: '',
  #   client: '',
  #   uid: '',
end
