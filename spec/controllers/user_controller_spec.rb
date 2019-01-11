require 'pry'
require_relative '../spec_helper'

describe UsersController do
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

  context 'when logged in,' do
    before(:each) do
      page.set_rack_session(user_id: @user1.id)
    end

    describe 'logging out' do
      it 'clears the session' do
        page.driver.submit :post, '/logout', nil

        expect(page.get_rack_session['user_id']).to be_nil
      end
    end

    describe "navigating to '/login'" do
      it 'redirects to profile' do
        visit '/login'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user1.id}")
      end
    end

    describe "navigating to '/signup'" do
      it 'redirects to profile' do
        visit '/signup'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user1.id}")
      end
    end

    describe 'navigating to profile' do
      it 'loads /users/:id' do
        visit "/users/#{@user1.id}"
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user1.id}")
      end

      it 'displays all user reviews' do
        visit "/users/#{@user1.id}"

        expect(page.body).to include(@user1.reviews.first[:content])
        expect(page.body).to include(@user1.reviews.last[:content])
      end

      it 'says there are no reviews if user has no reviews' do
        visit "/users/#{@user_with_no_reviews.id}"
        # binding.pry
        expect(page.body).to include("hasn't posted any reviews!")
      end
    end

    describe 'there should be' do
      it 'a logout button on each page' do
        visit '/'
        expect(page).to have_button('Log Out')
        visit '/users/1'
        expect(page).to have_button('Log Out')
      end

      it 'a user session' do
        expect(page.get_rack_session['user_id']).to_not be_nil
      end
    end
  end

  context 'when logged out,' do
    before(:each) do
      expect(page.get_rack_session['user_id']).to be_nil
    end

    describe 'logging in' do
      it "loads '/login'" do
        visit '/login'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/login')
      end

      it 'logs in an existing user' do
        visit '/login'
        fill_in(:username, with: @user1.username)
        fill_in(:password, with: 'password')
        click_button 'submit'
        # The 'user_id' key is saved as a string in the rack_session_access gem
        expect(page.get_rack_session['user_id']).to eq(@user1.id)
      end

      it "redirects to the user's profile page" do
        visit '/login'
        fill_in(:username, with: @user1.username)
        fill_in(:password, with: 'password')
        click_button 'submit'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user1.id}")
      end

      it 'persists through page loads' do
        visit '/login'
        fill_in(:username, with: @user1.username)
        fill_in(:password, with: 'password')
        click_button 'submit'
        visit '/users/1'
        visit '/'
        visit '/login'
        # The 'user_id' key is saved as a string in the rack_session_access gem
        expect(page.current_path).to eq("/users/#{@user1.id}")
        expect(page.get_rack_session['user_id']).to eq(@user1.id)
      end

      it 'rejects invalid log in' do
        visit '/login'
        fill_in(:username, with: @user1.username)
        fill_in(:password, with: 'not password')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/signup')
      end
    end

    describe 'signing up' do
      it "loads '/signup'" do
        visit '/signup'
        expect(page.status_code).to eq(200)
        expect(page.body).to include('Sign up')
      end

      it "redirects to '/login' after signing up" do
        params = {
          username: 'username5',
          email: 'email5',
          password: 'password5'
        }

        visit '/signup'
        fill_in(:username, with: params[:username])
        fill_in(:email, with: params[:email])
        fill_in(:password, with: params[:password])
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/login')
      end

      it 'creates a new user' do
        params = {
          username: 'username4',
          email: 'email4',
          password: 'password4'
        }

        visit '/signup'
        fill_in(:username, with: params[:username])
        fill_in(:email, with: params[:email])
        fill_in(:password, with: params[:password])
        click_button 'submit'

        new_user = User.all.last
        expect(new_user.username).to eq(params[:username])
        expect(new_user.email).to eq(params[:email])
      end
    end

    describe 'rejects signup when' do
      it 'password is blank' do
        visit '/signup'
        fill_in(:username, with: 'usernamez')
        fill_in(:email, with: 'emailz')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/signup')
      end

      it 'username is blank' do
        visit '/signup'
        fill_in(:email, with: 'emailz')
        fill_in(:password, with: 'passwordz')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/signup')
      end

      it 'email is blank' do
        visit '/signup'
        fill_in(:username, with: 'usernamez')
        fill_in(:password, with: 'passwordz')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/signup')
      end

      it 'username exists' do
        visit '/signup'
        fill_in(:username, with: @user1.username)
        fill_in(:email, with: 'emailz')
        fill_in(:password, with: 'passwordz')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/signup')
      end

      it 'email exists' do
        visit '/signup'
        fill_in(:username, with: 'name')
        fill_in(:email, with: @user1.email)
        fill_in(:password, with: 'passwordz')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/signup')
      end
    end

    describe 'there should be' do
      it 'a login link on each page' do
        visit '/'
        expect(page).to have_link('Log In', href: '/login')
        expect(page).to have_link('Sign Up', href: '/signup')
        visit '/login'
        expect(page).to have_link('Log In', href: '/login')
        expect(page).to have_link('Sign Up', href: '/signup')
      end
    end

    describe 'there should not be' do
      it 'any user session' do
        expect(page.get_rack_session['user_id']).to be_nil
      end
    end
  end
end
