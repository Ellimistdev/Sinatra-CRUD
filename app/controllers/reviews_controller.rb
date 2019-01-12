# Manages reviews-based routing, helpers, sessions
class ReviewsController < ApplicationController
  # POST: /reviews
  post '/reviews' do
    movie = Movie.find_by(id: params[:movie_id])
    identical = !!movie.reviews.detect { |review| review.content == params[:content] && review.user_id == session[:user_id] }
    redirect "/movies/#{params[:movie_id]}" if params.values.any?(&:empty?) || identical

    review = Review.create(
      content: params[:content],
      rating: params[:rating],
      movie_id: params[:movie_id],
      user_id: session[:user_id]
    )
    redirect "/movies/#{review.movie_id}"
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
    redirect :/
  end
end
