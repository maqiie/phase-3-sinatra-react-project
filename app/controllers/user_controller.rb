class UserController < ApplicationController
    # read JSON body
    before do
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
  
      begin
        @user = user_data
      rescue StandardError
        @user = nil
      end
    end
  
    #  registers a new user to the data base
    post '/register' do
      begin
        users = User.create(@user)
        users.to_json
      rescue => e
        { error: e.message }.to_json
      end
    end
  
    # logs in user using email and password
    post '/login' do
      begin
        user_data = User.find_by(email: @user['email'])
        if user_data.passwordHash == @user['passwordHash']
          response(code: 200, data: { id: user_data.id, email: user_data.email })
        else
          response(
            code: 422,
            data: {
              message: 'Your email/password combination is not correct',
            },
          )
        end
      rescue => e
        { error: e.message }.to_json
      end
    end
  
    #    displays all users
    get '/users' do
      user = User.all
      user.to_json
    end
  
    #gets all projects a user has
    get '/user/projects/:id' do
      user = User.find_by(id: params[:id])
      projects = user.projects
      projects.to_json
    end
  
    private
  
    # parse  JSON data
    def user_data
      JSON.parse(request.body.read)
    end
  
    def response(code: 200, data: nil)
      status = [200, 201].include?(code) ? 'SUCCESS' : 'FAILED'
      headers['Content-Type'] = 'application/json'
      [code, { data: data, message: status }.to_json] if data
    end
  end
  