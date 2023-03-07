class UserController < ApplicationController

  def change
    add_column :users, :name, :string
  end

  # read JSON body
  before do
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
    content_type :json
    begin
      @user = user_data
    rescue StandardError
      @user = nil
    end
  end

  # registers a new user to the data base
  post '/register' do
    begin
      user = User.create(
        name: @user['name'],
        email: @user['email'],
        passwordHash: @user['passwordHash']
      )
      build_response(code: 200, data: user)
    rescue => e
      build_response(code: 500, error: e.message)
    end
  end

  # # logs in user using email and password
  post '/login' do
    begin
      user_data = User.find_by(email: @user['email'])
      if user_data && user_data.passwordHash == @user['passwordHash']
        build_response(code: 200, data: { id: user_data.id, email: user_data.email })
      else
        build_response(
          code: 422,
          data: {
            message: 'Your email/password combination is not correct',
          },
        )
      end
    rescue => e
      build_response(code: 500, error: e.message)
    end
  end
  # post '/login' do
  #   begin
  #     user_data = User.find_by(email: params['email'])
  #     if user_data && user_data.passwordHash == params['password']
  #       build_response(code: 200, data: { id: user_data.id, email: user_data.email })
  #     else
  #       build_response(
  #         code: 422,
  #         data: {
  #           message: 'Your email/password combination is not correct',
  #         },
  #       )
  #     end
  #   rescue => e
  #     build_response(code: 500, error: e.message)
  #   end
  # end
  
  # displays all users
  get '/users' do
    user = User.all
    build_response(code: 200, data: user)
  end
    
# deletes a user
delete '/destroy/:id' do
  begin
    user = User.find(params[:id].to_i)
    if user.nil?
      response(code: 404, data: { error: 'User not found' })
    else
      user.destroy
      response(data: { message: 'User deleted successfully' })
    end
  rescue ActiveRecord::RecordNotFound
    response(code: 404, data: { error: 'User not found' })
  rescue => e
    response(code: 500, data: { error: e.message })
  end
end


  # gets all projects a user has
  get '/user/projects/:id' do
    user = User.find_by(id: params[:id])
    projects = user.projects
    build_response(code: 200, data: projects)
  end

  private

  # parse  JSON data
  def user_data
    json = JSON.parse(request.body.read)
    { name: json['name'], email: json['email'], passwordHash: json['passwordHash'] }
  end

  def build_response(code:, data: nil, error: nil)
    status = [200, 201].include?(code) ? 'SUCCESS' : 'FAILED'
    headers['Content-Type'] = 'application/json'
    if data
      [code, { data: data, message: status }.to_json]
    elsif error
      [code, { error: error, message: status }.to_json]
    end
  end
end
