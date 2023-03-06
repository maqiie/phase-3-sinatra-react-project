class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end
get '/users' do
  @users=User.all.to_json
end
get '/projects' do 
  @projects=Project.all.to_json
end
end
