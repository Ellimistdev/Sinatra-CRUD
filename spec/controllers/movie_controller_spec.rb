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

  describe 'viewing the homepage' do
    it 'lists all the movies' do
      visit '/movies'
      expect(page.body).to include(Movie.all.first[:name])
      expect(page.body).to include(Movie.all.last[:name])
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
