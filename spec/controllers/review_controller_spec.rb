require_relative '../spec_helper'
describe ReviewsController do
  before(:each) do
    @user = User.create(username: 'user', email: 'email', password: 'password')
    @user2 = User.create(username: 'user2', email: 'email2', password: 'password2')
    @movie = Movie.create(name: 'The movie')
    @review = Review.create(content: 'a review', rating: 5)
    @review.reviewer = @user
    @review.movie = @movie
    @review.save
    @review_unowned = Review.create(content: 'a different review', rating: 5)
    @review_unowned.reviewer = @user2
    @review_unowned.movie = @movie
    @review_unowned.save
  end
  context 'when logged in,' do
    before(:each) do
      page.set_rack_session(user_id: @user.id)
    end

    describe 'create new review' do
      it 'loads the new review form' do
        visit "/movies/1"
        expect(page.status_code).to eq(200)
        expect(page.body).to include('Add a review')
      end

      it 'creates a new review' do
        params = {
          content: 'good movie',
          rating: 5
        }
        visit "/movies/1"
        fill_in(:content, with: params[:content])
        select params[:rating], from: :rating
        click_button 'submit'
        review = @user.reviews.find_by(content: params[:content])

        expect(review.user_id).to eq(@user.id)
        expect(review.movie_id).to eq(@movie.id)
        expect(review.content).to eq(params[:content])
        expect(review.rating).to eq(params[:rating])
        expect(page.current_path).to eq("/movies/1")
      end

      it 'informs user when review is invalid' do
        visit '/movies/1'
        fill_in(:content, with: '')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/movies/1')
        expect(page.body).to include('Invalid form submission')
      end

      describe 'rejects review creation when' do
        it 'content is blank' do
          visit "/movies/1"
          fill_in(:content, with: '')
          click_button 'submit'

          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq("/movies/1")
        end

        it 'content, movie_id, and user_id are identical' do
          visit "/movies/1"
          fill_in(:content, with: @review.content)
          select 5, from: :rating
          click_button 'submit'
          count = @movie.reviews.select { |review| review.content == @review.content }.length
          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq("/movies/1")
          expect(count).to eq(1)
        end
      end
    end

    describe 'user is allowed to' do
      it 'edit their own review' do 
        update = 'updated review via page.driver patch'
        page.driver.submit :patch, "/reviews/#{@review.id}", content: update
        expect(@review[:content]).to eq(update)
      end

      it 'delete their own review' do
        page.driver.submit :delete, "/reviews/#{@review.id}", nil
        # @review is deleted, Review should only have @review_unowned
        expect(Review.all.last).to eq(@review_unowned)
      end
    end

    describe 'user is not allowed to' do 
      it "edit someone else's review" do 
        update = 'updated review I do not own via page.driver patch'
        page.driver.submit :patch, "/reviews/#{@review_unowned.id}", content: update
        expect(@review_unowned[:content]).to_not eq(update)
      end

      it "delete someone else's review" do
        page.driver.submit :delete, "/reviews/#{@review_unowned.id}", nil
        # @review_unowned is not deleted
        expect(Review.find_by(id: @review_unowned.id)).to be_truthy
      end
    end

    describe 'user has the ability to' do
      it 'edit their own review' do 
        update = 'updated review via form submission patch'
        target_review_id = @user.reviews.first[:id]
        visit "/reviews/#{target_review_id}/edit"
        fill_in(:content, with: update)
        click_button 'update'

        expect(@review[:content]).to eq(update)
      end

      it 'delete their own review from movie page' do
        target_movie_id = @user.reviews.first[:movie_id]
        visit "/movies/#{target_movie_id}"

        # find @user.reviews.first[:id] delete button
        # click it
        # @review is deleted, user's first review should not equal target id
        expect(@user.reviews.first[:movie_id]).to_not eq(target_movie_id)
        # page is reloaded
        expect(page.current_path).to eq("/movies/#{target_movie_id}")        
      end

      it 'delete their own review from profile page' do
        target_movie_id = @user.reviews.first[:movie_id]
        visit "/users/#{@user.id}"

        # find @user.reviews.first[:id] delete button
        # click it
        # @review is deleted, user's first review should not equal target id
        expect(@user.reviews.first[:movie_id]).to_not eq(target_movie_id)
        # page is reloaded
        expect(page.current_path).to eq("/movies/#{target_movie_id}")
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
