# Manages user-based routing, helpers, sessions
class UsersController < ApplicationController
  get '/signup' do
    erb :'/users/new.html'
  end

  get '/login' do
    erb :'/users/login.html'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    # binding.pry
    redirect '/signup' unless user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  end

  post '/logout' do
    # session.destroy
    redirect '/'
  end

  # shows all reviews by user
  get '/users/:id' do
    erb :'/users/show.html'
  end

  # create new user
  post '/users/new' do
    # there's no way that posting a clear password like this is secure
    User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
    redirect '/login'
  end

  # GET: /users
  # get '/users' do
  #   erb :'/users/index.html'
  # end

  # GET: /users/5/edit
  # get '/users/:id/edit' do
  #   erb :'/users/edit.html'
  # end

  # PATCH: /users/5
  # patch '/users/:id' do
  #   redirect '/users/:id'
  # end

  # DELETE: /users/5/delete
  # delete '/users/:id/delete' do
  #   redirect '/users'
  # end
end
