Apipie.configure do |config|
  config.app_name                = "TaskManagementApp"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.validate = false
  config.validate_value = false
  config.reload_controllers = Rails.env.development?
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "**","*.rb")
  config.api_routes = Rails.application.routes
end
