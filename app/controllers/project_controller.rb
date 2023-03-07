
class ProjectController < ApplicationController
  # returns all projects in the db
  get '/projects' do
    projects = Project.all
    projects.to_json
  end

  post '/project/create' do
    data = JSON.parse(request.body.read)
    begin
      project = Project.create(title: data['title'], description: data['description'])
      project.to_json
    rescue => e
      { error: e.message }.to_json
    end
  end

  # updates a project
  put '/project/update/:id' do
    data = JSON.parse(request.body.read)
    begin
      project = Project.find(params[:id].to_i)
      project.update(data)
      response(data: { message: 'Project updated successfully' })
    rescue => e
      response(code: 422, data: { error: e.message })
    end
  end

  # updates status of a project
  put '/project/update/status/:id' do
    data = JSON.parse(request.body.read)
    begin
      project = Project.find(params[:id].to_i)
      project.update(data)
      response(data: { message: 'status updated successfully' })
    rescue => e
      response(code: 422, data: { error: e.message })
    end
  end
  # Add a route to add a user to a project
post '/project/:id/user' do
  project = Project.find(params[:id])
  user = User.find(params[:user_id])
  project.users << user
  project.to_json(include: :users)
end

# Add a many-to-many relationship between Project and User
class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
end

class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
end


  # deletes a project
  delete '/destroy/:id' do
    begin
      project = Project.find(params[:id].to_i)
      if project.nil?
        response(code: 404, data: { error: 'Project not found' })
      else
        project.destroy
        response(data: { message: 'Project deleted successfully' })
      end
    rescue ActiveRecord::RecordNotFound
      response(code: 404, data: { error: 'Project not found' })
    rescue => e
      response(code: 500, data: { error: e.message })
    end
  end
  
end
