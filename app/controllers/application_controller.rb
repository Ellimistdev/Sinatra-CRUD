require './config/environment'

# Manages non-model-based routing, helpers, sessions
class ApplicationController < Sinatra::Base
  configure do
    enable :sessions
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, ENV['SESSION_SECRET']
  end

  get '/' do
    redirect :movies
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def session_info
      session
    end
  end
end
