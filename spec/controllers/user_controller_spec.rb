require_relative '../spec_helper'

describe UsersController do
  before(:each) do
    @user = User.create(username: 'user', email: 'email', password: 'password')
    @user2 = User.create(username: 'user2', email: 'email2', password: 'password2')
    @movie = Movie.create(name: 'The movie')
    @movie2 = Movie.create(name: 'The movie, the sequel')
    review1 = Review.create(content: 'good movie', rating: 5, user_id: @user.id, movie_id: @movie.id)
    review2 = Review.create(content: 'okay movie', rating: 3, user_id: @user.id, movie_id: @movie2.id)
    review3 = Review.create(content: 'meh movie', rating: 2, user_id: @user2.id, movie_id: @movie.id)
    review4 = Review.create(content: 'bad movie', rating: 1, user_id: @user2.id, movie_id: @movie2.id)
  end

  context 'when logged in,' do
    before(:each) do
      page.set_rack_session(user_id: @user.id)
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
        expect(page.current_path).to eq("/users/#{@user.id}")
      end
    end

    describe "navigating to '/signup'" do
      it 'redirects to profile' do 
        visit '/signup'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user.id}")
      end
    end

    describe 'navigating to profile' do
      it 'loads /users/:id' do
        visit "/users/#{@user.id}"
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user.id}")        
      end

      it 'displays all user reviews' do
        visit "/users/#{@user.id}"

        expect(page.body).to include(@user.reviews.first[:content])        
        expect(page.body).to include(@user.reviews.last[:content])        
      end
    end
  end

  context 'when logged out,' do
    describe 'logging in' do
      it "loads '/login'" do
        visit '/login'
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq('/login')
      end

      it 'logs in an existing user' do
        visit '/login'
        fill_in(:username, with: @user.username)
        fill_in(:password, with: 'password')
        click_button 'submit'
        # The 'user_id' key is saved as a string in the rack_session_access gem
        expect(page.get_rack_session['user_id']).to eq(@user.id)
      end

      it "redirects to the user's profile page" do
        visit '/login'
        fill_in(:username, with: @user.username)
        fill_in(:password, with: 'password')
        click_button 'submit'

        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user.id}")
      end

      it 'rejects invalid log in' do
        visit '/login'
        fill_in(:username, with: @user.username)
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
          username: 'username3',
          email: 'email3',
          password: 'password3'
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
          username: 'username3',
          email: 'email3',
          password: 'password3'
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
  end
end
