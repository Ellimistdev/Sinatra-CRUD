# Manages user-based routing, helpers, sessions
class UsersController < ApplicationController
  get '/login' do
    redirect "/users/#{session[:user_id]}" if session[:user_id]
    erb :'/users/login.html'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    redirect :signup unless user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  end

  post '/logout' do
    session.destroy
    redirect :/
  end

  # shows all reviews by user
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    redirect back unless @user
    erb :'/users/show.html'
  end

  get '/signup' do
    redirect "/users/#{session[:user_id]}" if session[:user_id]
    erb :'/users/new.html'
  end

  # create new user
  post '/signup' do
    redirect :signup if params.values.any?(&:empty?) ||
                        User.find_by(username: params[:username]) ||
                        User.find_by(email: params[:email])
    # there's no way that posting a clear password like this is secure
    User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
    redirect :login
  end
end
