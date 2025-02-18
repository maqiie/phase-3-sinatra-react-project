require_relative "./config/environment"
require './app/controllers/user_controller'
require './app/controllers/project_controller'

# Allow CORS (Cross-Origin Resource Sharing) requests
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :delete, :put, :patch, :options, :head]
  end
end

# Parse JSON from the request body into the params hash
use Rack::JSONBodyParser
use ApplicationController
use ProjectController
run UserController
