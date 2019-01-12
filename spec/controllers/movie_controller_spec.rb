require_relative '../spec_helper'

describe MoviesController do
  before(:each) do
    @user1 = User.create(username: 'user', email: 'email', password: 'password')
    @user2 = User.create(username: 'user2', email: 'email2', password: 'password2')
    @user_with_no_reviews = User.create(username: 'user3', email: 'email3', password: 'password3')
    @movie = Movie.create(name: 'The movie')
    @movie2 = Movie.create(name: 'The movie, the sequel')
    Review.create(content: 'good movie', rating: 5, user_id: @user1.id, movie_id: @movie.id)
    Review.create(content: 'okay movie', rating: 3, user_id: @user1.id, movie_id: @movie2.id)
    Review.create(content: 'meh movie', rating: 2, user_id: @user2.id, movie_id: @movie.id)
    Review.create(content: 'bad movie', rating: 1, user_id: @user2.id, movie_id: @movie2.id)
  end

  describe 'viewing the movie index' do
    it 'lists all the movies' do
      visit '/movies'
      expect(page.body).to include(Movie.all.first[:name])
      expect(page.body).to include(Movie.all.last[:name])
    end

    it 'has a link to each movie page' do
      movies = Movie.all
      visit '/movies'
      expect(page).to have_link(movies.first.name, href: "/movies/#{movies.first[:id]}")
      expect(page).to have_link(movies.last.name, href: "/movies/#{movies.last[:id]}")
    end
  end

  describe 'viewing a Movie page' do
    it 'loads the page' do
      visit '/movies/1'
      expect(page.status_code).to eq(200)
    end

    it 'lists all the reviews for that movie' do
      visit '/movies/1'
      expect(page.body).to include(@movie.reviews.first[:content])
      expect(page.body).to include(@movie.reviews.last[:content])
    end

    it 'has link to user for each review' do
      visit "/movies/1"
      first_user_id = @movie.reviews.first[:user_id]
      last_user_id = @movie.reviews.last[:user_id]
      expect(page).to have_link(@user1.username, href:"/users/#{first_user_id}")
      expect(page).to have_link(@user2.username, href:"/users/#{last_user_id}")
    end
  end

  describe 'updating a review from the movie page,' do
    context 'when own review' do 
      before(:each) do
        page.set_rack_session(user_id: @user1.id)
      end

      it 'has link to edit each review' do
        visit "/movies/1"
        relevant_reviews = @user1.reviews.select { |review| review[:movie_id] == 1 }
        within '.current_user_actions' do
          expect(page).to have_link(href: "/reviews/#{relevant_reviews.first[:id]}/edit")
          expect(page).to have_link(href: "/reviews/#{relevant_reviews.last[:id]}/edit")
        end
      end

      it 'has link to delete review by user1' do
        visit "/movies/1"
        relevant_reviews = @user1.reviews.select { |review| review[:movie_id] == 1 }
        within('.current_user_actions') do
          # test to ensure this is @user1
          expect(page).to have_button('delete review')
        end
      end

      it 'has link to delete review by user2' do
        page.set_rack_session(user_id: @user2.id)
        visit "/movies/1"
        relevant_reviews = @user2.reviews.select { |review| review[:movie_id] == 1 }
        within('.current_user_actions') do
          # test to ensure this is @user2
          expect(page).to have_button('delete review')
        end
      end
    end

    context 'when do not own review' do
      before(:each) do
        page.set_rack_session(user_id: @user1.id)
      end

      it 'does not have link to edit review' do
        visit "/movies/1"
        expect(page).to_not have_link('edit review', href: "/reviews/#{@user2.reviews.first[:id]}/edit")
        expect(page).to_not have_link('edit review', href: "/reviews/#{@user2.reviews.last[:id]}/edit")
      end
    end

    context 'when guest, ' do
      it 'does not have link to delete review' do
        visit "/movies/1"
        # this serves to test that the delete review button is not present 
        # outside the div.current_user_actions as it should not be rendered
        # there does not appear to be a 'without' capybara selector
        expect(page).to_not have_button('delete review')
      end
    end
  end

  describe 'creating a new movie' do
    it 'loads the new movie form' do
      visit '/movies/new'

      expect(page.status_code).to eq(200)
      expect(page.body).to include('Add a Movie')
    end

    it 'creates a new movie' do
      movie_name = 'a new movie'
      visit '/movies/new'
      fill_in(:name, with: movie_name)
      click_button 'submit'
      movie = Movie.find_by(name: movie_name)
      expect(movie).to_not be_nil
    end

    it 'redirects to movie page after creation' do
      movie_name = 'a new movie'
      visit '/movies/new'
      fill_in(:name, with: movie_name)
      click_button 'submit'
      movie = Movie.find_by(name: movie_name)
      expect(page.current_path).to eq("/movies/#{movie.id}")
    end

    it 'informs user when movie is invalid' do
      visit '/movies/new'
      fill_in(:name, with: '')
      click_button 'submit'

      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq('/movies/new')
      expect(page.body).to include('Invalid Movie:')
    end
  end

  describe 'rejects movie creation when' do
    it 'name is blank' do
      visit '/movies/new'
      fill_in(:name, with: '')
      click_button 'submit'

      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq('/movies/new')
    end

    it 'movie exists' do
      visit '/movies/new'
      fill_in(:name, with: @movie.name)
      click_button 'submit'

      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq('/movies/new')
    end
  end
end
