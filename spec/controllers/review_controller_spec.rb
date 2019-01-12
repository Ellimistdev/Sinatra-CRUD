require_relative '../spec_helper'
describe ReviewsController do
  before(:each) do
    @user = User.create(username: 'user', email: 'email', password: 'password')
    @movie = Movie.create(name: 'The movie')
    @review = Review.create(content: 'a review', rating: 5, movie_id: @movie.id, user_id: @user.id)
    @review_unowned = Review.create(content: 'a review', rating: 5, movie_id: @movie.id, user_id: 2)
  end
  context 'when logged in,' do
    before(:each) do
      page.set_rack_session(user_id: @user.id)
    end

    describe 'create new review' do
      it 'loads the new review form' do
        visit "/movies/#{@movie.id}"

        expect(page.status_code).to eq(200)
        expect(page.body).to include('Add a review')
      end

      it 'creates a new review' do
        params = {
          content: 'good movie',
          rating: 5
        }
        visit "/movies/#{@movie.id}"
        fill_in(:content, with: params[:content])
        select params[:rating], from: :rating
        click_button 'submit'
        review = @user.reviews.find_by(content: params[:content])

        expect(review.user_id).to eq(@user.id)
        expect(review.movie_id).to eq(@movie.id)
        expect(review.content).to eq(params[:content])
        expect(review.rating).to eq(params[:rating])
        expect(page.current_path).to eq("/movies/#{@movie.id}")
      end

      it 'informs user when review is invalid' do
        visit "/movies/#{@movie.id}"
        fill_in(:content, with: '')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/movies/#{@movie.id}")
        expect(page.body).to include('Invalid Review:')
      end

      describe 'rejects review creation when' do
        it 'content is blank' do
          visit "/movies/#{@movie.id}"
          fill_in(:content, with: '')
          click_button 'submit'

          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq("/movies/#{@movie.id}")
        end

        it 'content, movie_id, and user_id are identical' do
          visit "/movies/#{@movie.id}"
          fill_in(:content, with: @review.content)
          select 5, from: :rating
          click_button 'submit'
          count = @movie.reviews.select { |review| review.content == @review.content }.length

          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq("/movies/#{@movie.id}")
          expect(count).to eq(1)
        end
      end
    end

    describe 'user can' do
      it 'edit their own review' do 
        update = 'updated review via page.driver patch'
        page.driver.submit :patch, "/reviews/#{@review.id}", content: update
        expect(@review[:content]).to eq(update)
      end

      it 'delete their own review' do
        page.driver.submit :delete, "/reviews/#{@review.id}", nil
        # @review is deleted, Review should only have @review_unowned
        expect(Review.all.last)).to eq(@review_unowned)
      end
    end

    describe 'user can not' do 
      it "edit someone else's review" do 
        update = 'updated review I do not own via page.driver patch'
        page.driver.submit :patch, "/reviews/#{@review_unowned.id}", content: update
        expect(@review_unowned[:content]).to_not eq(update)
      end

      it "delete someone else's review" do
        page.driver.submit :delete, "/reviews/#{@review_unowned.id}", nil
        # @review_unowned is not deleted
        expect(Review.find_by(id: @review_unowned.id))).to be_truthy
      end
    end
  end
  context 'when logged out,' do
    it 'does not display create a review form' do
      visit "/movies/#{@movie.id}"
      # might not work
      expect(page.has_field?(:content)).to be false
    end
  end
end
