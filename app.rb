# require 'sinatra'
# require 'json'
# require 'sinatra/activerecord'

# set :port, 3001 # or any other port you prefer
# set :database, { adapter: 'sqlite3', database: 'db.sqlite3' }

# class User < ActiveRecord::Base
# end

# class App < Sinatra::Base

#   before do
#     content_type :json
#   end


 
#   get '/projects' do
#     # Return a list of projects as JSON
#     [
#       { title: 'Project 1', description: 'This is project 1', completed: false },
#       { title: 'Project 2', description: 'This is project 2', completed: true }
#     ].to_json
#   end

#   post '/projects' do
#     # Create a new project and return it as JSON
#     { 
#       title: params[:title], 
#       description: params[:description], 
#       completed: params[:completed] == 'true' 
#     }.to_json
#   end

#   delete '/projects/:id' do
#     # Delete the project with the given ID
#     "Project #{params[:id]} deleted"
#   end

#   post '/users' do
#     # Create a new user and return it as JSON
#     user = User.create(
#       email: params[:email],
#       password: params[:password],
#       role: params[:role]
#     )
#     user.to_json
#   end
# end
require 'sinatra'
require 'json'
require 'sinatra/activerecord'
require 'bcrypt'

set :port, 3001 # or any other port you prefer
set :database, { adapter: 'sqlite3', database: 'db.sqlite3' }

class User < ActiveRecord::Base
  # Encrypt password before saving to database
  before_save :encrypt_password

  # Authenticate user with email and password
  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    nil
  end

  private

  # Encrypt password with BCrypt
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end

class App < Sinatra::Base

  before do
    content_type :json
  end

  # Route for user registration
  post '/register' do
    # Create a new user and return it as JSON
    user = User.create(
      email: params[:email],
      password: params[:password],
      role: params[:role]
    )
    user.to_json
  end

  # Route for user authentication
  post '/login' do
    # Authenticate user with email and password
    user = User.authenticate(params[:email], params[:password])
    if user
      # Return user as JSON
      user.to_json
    else
      # Return error message as JSON
      { error: 'Invalid email or password' }.to_json
    end
  end

end
