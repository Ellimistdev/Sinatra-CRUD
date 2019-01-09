class MoviesController < ApplicationController

  get "/movies/new" do
    erb :"/movies/new.html"
  end
  
  post "/movies" do
    # create movie
    # redirect "/movies/#{movie.id}"
    redirect "/"
  end
  
  get "/movies/:id" do
    # get reviews for movie 
    erb :"/movies/show.html"
  end
  
  # get "/movies" do
  #   erb :"/movies/index.html"
  # end
  
  # GET: /movies/5/edit
  # get "/movies/:id/edit" do
  #   erb :"/movies/edit.html"
  # end

  # PATCH: /movies/5
  # patch "/movies/:id" do
  #   redirect "/movies/:id"
  # end

  # DELETE: /movies/5/delete
  # delete "/movies/:id/delete" do
  #   redirect "/movies"
  # end
end
