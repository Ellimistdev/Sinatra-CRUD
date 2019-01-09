require_relative '../spec_helper'
describe ReviewsController do
  context 'logged in' do
    describe 'create new review' do
      it 'loads the new review form' do
        user = User.create(username: 'user', email: 'email', password: 'password')
        visit '/login'
        fill_in(:username, with: user.username)
        fill_in(:password, with: 'password')
        click_button 'submit'

        movie = Movie.create(name: 'The movie')
        get "/movies/#{movie.id}"

        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Add a review')
      end

      it 'creates a new review' do
        user = User.create(username: 'user', email: 'email', password: 'password')
        visit '/login'
        fill_in(:username, with: user.username)
        fill_in(:password, with: 'password')
        click_button 'submit'

        movie = Movie.create(name: 'The movie')
        params = {
          content: 'good movie',
          rating: 5
        }
        visit "/movies/#{movie.id}"
        fill_in(:content, with: params[:content])
        select params[:rating], from: :rating
        click_button 'submit'
        review = user.reviews.find_by(content: params[:content])
        expect(review.user_id).to eq(user.id)
        expect(review.movie_id).to eq(movie.id)
        expect(review.content).to eq(params[:content])
        expect(review.rating).to eq(params[:rating])
        expect(page.current_path).to eq("/movies/#{movie.id}")
      end

      # it 'does not allow empty reviews' do
      #   params = {
      #     content: '',
      #     rating: 5,
      #     movie_id: 1,
      #     user_id: 1
      #   }
      #   post '/reviews', params
      #   expect(Reviews.find_by(content: params[:content])).to eq(nil)
      #   expect(page.current_path).to eq('/reviews/new')
      # end
    end
  end
  # context 'logged out' do
  #   it 'does not let a guest create a review' do
  #     get '/reviews/new'
  #     expect(last_response.location).to include('/login')
  #   end
  # end
end
