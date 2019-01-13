require_relative '../spec_helper'
describe ReviewsController do
  before do
    @users = User.all
    @user = @users.first
    @movies = Movie.all
    @reviews = Review.all
  end
  context 'when logged in,' do
    before do
      page.set_rack_session(user_id: @user.id)
    end

    describe 'create new review' do
      it 'loads the new review form' do
        visit '/movies/1'
        expect(page.status_code).to eq(200)
        expect(page.body).to include('Add a review')
      end

      it 'creates a new review' do
        params = {
          content: 'good movie',
          rating: 5
        }
        visit '/movies/1'
        fill_in(:content, with: params[:content])
        select params[:rating], from: :rating
        click_button 'submit'
        review = @user.reviews.find_by(content: params[:content])

        expect(review.user_id).to eq(@user.id)
        expect(review.movie_id).to eq(1)
        expect(review.content).to eq(params[:content])
        expect(review.rating).to eq(params[:rating])
        expect(page.current_path).to eq('/movies/1')
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
          visit '/movies/1'
          fill_in(:content, with: '')
          click_button 'submit'

          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq('/movies/1')
        end

        it 'content, movie_id, and user_id are identical' do
          visit '/movies/1'
          original_content = @movies.first.reviews.first[:content]
          fill_in(:content, with: original_content)
          select 5, from: :rating
          click_button 'submit'
          count = @movies.first.reviews.select { |review| review.content == original_content }.length
          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq('/movies/1')
          expect(count).to eq(1)
        end
      end
    end

    describe 'user is allowed to' do
      it 'edit their own review' do
        update = 'updated review via page.driver patch'
        page.driver.submit :patch, "/reviews/#{@reviews.first.id}", content: update
        updated_review = Review.find(@reviews.first[:id])
        expect(updated_review[:content]).to eq(update)
      end

      it 'delete their own review' do
        review = @users.first.reviews.first
        page.driver.submit :delete, "/reviews/#{review.id}/delete", nil
        expect(Review.exists?(review.id)).to be false
      end
    end

    describe 'user is not allowed to' do
      it "edit someone else's review" do
        update = 'updated review I do not own via page.driver patch'
        review_unowned = @users.last.reviews.first
        page.driver.submit :patch, "/reviews/#{review_unowned.id}", content: update
        expect(review_unowned[:content]).to_not eq(update)
      end

      it "delete someone else's review" do
        review_unowned = @users.last.reviews.first
        page.driver.submit :delete, "/reviews/#{review_unowned.id}", nil
        expect(Review.exists?(review_unowned.id)).to be true
      end
    end

    describe 'user has the ability to' do
      it 'edit their own review' do
        update = 'updated review via form submission patch'
        target_review_id = @user.reviews.first[:id]
        visit "/reviews/#{target_review_id}/edit"
        fill_in(:content, with: update)
        click_button 'update'
        updated_review = Review.find(target_review_id)

        expect(updated_review[:content]).to eq(update)
      end

      it 'delete their own review from movie page' do
        target_movie_id = @user.reviews.first[:movie_id]
        review_count = @user.reviews.length
        visit "/movies/#{target_movie_id}"
        within ".current_user_actions_review_#{@user.reviews.first[:id]}" do
          click_button('delete')
        end
        updated_user = User.find(@user.id)
        expect(updated_user.reviews.length).to_not eq(review_count)
        # page is reloaded
        expect(page.current_path).to eq("/movies/#{target_movie_id}")
      end

      it 'delete their own review from profile page' do
        # since we're using seed data by suite, not test, grab a different user
        user = @users[2]
        page.set_rack_session(user_id: user.id)

        review_count = user.reviews.length
        visit "/users/#{user.id}"
        within ".current_user_actions_review_#{user.reviews.first[:id]}" do
          click_button('delete')
        end
        updated_user = User.find(user.id)
        expect(updated_user.reviews.length).to_not eq(review_count)
        # page is reloaded
        expect(page.current_path).to eq("/users/#{user.id}")
      end
    end
  end
  context 'when logged out,' do
    it 'does not display create a review form' do
      visit '/movies/1'
      expect(page.has_field?(:content)).to be false
    end
  end
end
