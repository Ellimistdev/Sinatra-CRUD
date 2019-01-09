# Manages reviews-based routing, helpers, sessions
class ReviewsController < ApplicationController
  # GET: /reviews/new
  get '/reviews/new' do
    erb :'/reviews/new.html'
  end

  # POST: /reviews
  post '/reviews' do
    # create review
    # redirect to review
    redirect '/reviews/'
  end

  # GET: /reviews/5
  get '/reviews/:id' do
    erb :'/reviews/show.html'
  end

  # GET: /reviews/5/edit
  get '/reviews/:id/edit' do
    erb :'/reviews/edit.html'
  end

  # PATCH: /reviews/5
  patch '/reviews/:id' do
    # update review
    redirect '/reviews/:id'
  end

  # DELETE: /reviews/5/delete
  delete '/reviews/:id/delete' do
    # delete the review
    # redirect to /movie/:movie_id
    redirect '/'
  end

  # GET: /reviews
  # get '/reviews' do
  #   erb :'/reviews/index.html'
  # end
end
