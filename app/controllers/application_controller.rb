class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
configure { enable :cross_origin }

before { response.headers['Access-Control-Allow-Origin'] = '*' }


 
get '/users' do
  users = User.all
  users.to_json
end
get '/projects' do 
  projects=Project.all.to_json
end
 get 'users/:id' do
  @users=User.find(params[:id])
  @users.to_json(include: :projects)
 end


end

