require_relative '../spec_helper'

describe MoviesController do
  before do
    @movies = Movie.all
  end
  describe 'viewing the movie index' do
    it 'lists all the movies' do
      visit '/movies'
      expect(page.body).to include(@movies.first[:name])
      expect(page.body).to include(@movies.last[:name])
    end

    it 'has a link to each movie page' do
      visit '/movies'
      expect(page).to have_link(@movies.first.name, href: "/movies/#{@movies.first[:id]}")
      expect(page).to have_link(@movies.last.name, href: "/movies/#{@movies.last[:id]}")
    end
  end

  describe 'viewing a Movie page' do
    it 'loads the page' do
      visit '/movies/1'
      expect(page.status_code).to eq(200)
    end

    it 'lists all the reviews for that movie' do
      visit '/movies/1'
      expect(page.body).to include(@movies.first.reviews.first[:content])
      expect(page.body).to include(@movies.first.reviews.last[:content])
    end

    it 'has link to user for each review' do
      visit '/movies/1'
      first_user_id = @movies.first.reviews.first[:user_id]
      last_user_id = @movies.first.reviews.last[:user_id]
      expect(page).to have_link(User.find(first_user_id).username, href: "/users/#{first_user_id}")
      expect(page).to have_link(User.find(last_user_id).username, href: "/users/#{last_user_id}")
    end
  end

  describe 'updating a review from the movie page,' do
    context 'when own review' do
      before do
        page.set_rack_session(user_id: 1)
      end

      it 'has link to edit each review' do
        visit '/movies/1'
        relevant_reviews = User.find(1).reviews.select { |review| review[:movie_id] == 1 }
        within '.current_user_actions' do
          expect(page).to have_link(href: "/reviews/#{relevant_reviews.first[:id]}/edit")
          expect(page).to have_link(href: "/reviews/#{relevant_reviews.last[:id]}/edit")
        end
      end

      it 'has link to delete review by user1' do
        visit '/movies/1'
        within('.current_user_actions') do
          expect(page).to have_button('delete review')
        end
      end
    end

    context 'when do not own review' do
      before do
        page.set_rack_session(user_id: 1)
      end

      it 'does not have link to edit review' do
        visit '/movies/1'
        user2 = User.find(2)
        expect(page).to_not have_link('edit review', href: "/reviews/#{user2.reviews.first[:id]}/edit")
        expect(page).to_not have_link('edit review', href: "/reviews/#{user2.reviews.last[:id]}/edit")
      end
    end

    context 'when guest, ' do
      it 'does not have link to delete review' do
        visit '/movies/1'
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
      movie_name = 'a different new movie'
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
      expect(page.body).to include('Invalid form submission')
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
      fill_in(:name, with: @movies.first.name)
      click_button 'submit'

      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq('/movies/new')
    end
  end
end
