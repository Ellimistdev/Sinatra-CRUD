# Manages movie-based routing, helpers, sessions
class MoviesController < ApplicationController
  get '/movies/new' do
    erb :'/movies/new.html'
  end

  post '/movies' do
    redirect '/movies/new' if params.values.any?(&:empty?) ||
                              Movie.find_by(name: params[:name])
    movie = Movie.create(
      name: params[:name]
    )
    redirect "/movies/#{movie.id}"
  end

  get '/movies/:id' do
    # get reviews for movie
    @movie = Movie.find_by(id: params[:id])
    redirect :'movies/new' unless @movie
    erb :'/movies/show.html'
  end

  get '/movies' do
    @movies = Movie.all
    erb :'/movies/index.html'
  end
end
