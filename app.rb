require 'sinatra'
require 'json'
require 'sinatra/activerecord'

set :port, 3001 # or any other port you prefer
set :database, { adapter: 'sqlite3', database: 'db.sqlite3' }

class User < ActiveRecord::Base
end

class App < Sinatra::Base

  before do
    content_type :json
  end


 
  get '/projects' do
    # Return a list of projects as JSON
    [
      { title: 'Project 1', description: 'This is project 1', completed: false },
      { title: 'Project 2', description: 'This is project 2', completed: true }
    ].to_json
  end

  post '/projects' do
    # Create a new project and return it as JSON
    { 
      title: params[:title], 
      description: params[:description], 
      completed: params[:completed] == 'true' 
    }.to_json
  end

  delete '/projects/:id' do
    # Delete the project with the given ID
    "Project #{params[:id]} deleted"
  end

  post '/users' do
    # Create a new user and return it as JSON
    user = User.create(
      email: params[:email],
      password: params[:password],
      role: params[:role]
    )
    user.to_json
  end
end
                                                                         