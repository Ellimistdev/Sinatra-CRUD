# Manages movie-based routing, helpers, sessions
class MoviesController < ApplicationController
  get '/movies/new' do
    @error = params[:error]
    erb :'/movies/new.html'
  end

  post '/movies' do
    redirect '/movies/new?error=Invalid form submission, please try again:' if params.values.any?(&:empty?) || Movie.find_by(name: params[:name])
    movie = Movie.create(
      name: params[:name]
    )
    redirect "/movies/#{movie.id}"
  end

  get '/movies/:id' do
    @movie = Movie.find_by(id: params[:id])
    redirect :'movies/new' unless @movie
    @error = params[:error]
    user_ids = @movie.reviews.map { |review| review[:user_id] }
    @users = User.all.select { |user| user_ids.include?(user.id) }
    erb :'/movies/show.html'
  end

  get '/movies' do
    @movies = Movie.all
    erb :'/movies/index.html'
  end
end
