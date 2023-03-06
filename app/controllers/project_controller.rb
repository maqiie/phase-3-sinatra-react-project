class ProjectController < ApplicationController
  # returns all projects in the db

  get '/projects' do
    projects = Project.all
    projects.to_json
  end

  # gives one project

  get '/project/:id' do
    project = Project.find(params[:id])
    project.to_json
  end

  # gives the names of the members of the project
  get '/project/members/:id' do
    project = Project.find_by(id: params[:id].to_i)
    members = project.users
    members.to_json
  end

  # creates a project

  post '/project/create/:id' do
    data = JSON.parse(request.body.read)
    begin
      project = Project.create(data)
      link = Link.create(user_id: params[:id].to_i, project_id: project.id)

      project.to_json
      link.to_json
    rescue => e
      { error: e.message }.to_json
    end
  end

  # gets the project id, search a user by name and adds the user as a member of the project

  post '/member/add/:userId/:projectId' do
    begin
      user = User.find(params[:userId].to_i)
      link = Link.create(user_id: user.id, project_id: params[:projectId].to_i)

      link.to_json
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

  # updates status of a prroject

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

  # deletes a project

  delete '/destroy/:id' do
    begin
      project = Project.find(params[:id].to_i)
      project.destroy

      response(data: { message: 'project deleted successfully' })
    rescue => e
      { error: e.message }.to_json
    end
  end
end
