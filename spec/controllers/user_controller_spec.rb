require_relative '../spec_helper'

describe UsersController do
  before(:each) do
    @user = User.create(username: 'user', email: 'email', password: 'password')
    @movie = Movie.create(name: 'The movie')
  end

  context 'when logged in' do
  end

  context 'when logged out' do
    describe 'loging in' do
      it "loads '/login'" do
        visit '/login'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Log in')
      end

      it 'logs in an existing user' do
        visit '/login'
        fill_in(:username, with: @user.username)
        fill_in(:password, with: 'password')
        click_button 'submit'

        expect(session[:user_id]).to eq(@user.id)
      end

      it 'redirects to profile page' do
        visit '/login'
        fill_in(:username, with: @user.username)
        fill_in(:password, with: 'password')
        click_button 'submit'

        expect(last_response.status).to eq(200)
        expect(page.current_path).to eq("/users/#{@user.id}")
      end

      it 'rejects invalid log in' do
        visit '/login'
        fill_in(:username, with: @user.username)
        fill_in(:password, with: 'not password')
        click_button 'submit'

        expect(last_response.status).to eq(200)
        expect(page.current_path).to eq('/signup')
      end
    end

    describe 'signing up' do
      it "loads '/signup'" do
        visit '/signup'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include('Sign up')
      end

      it "redirects to '/login'" do
        params = {
          username: 'username2',
          email: 'email2',
          password: 'password2'
        }

        visit '/signup'
        fill_in(:username, with: params[:username])
        fill_in(:email, with: params[:email])
        fill_in(:password, with: params[:password])
        click_button 'submit'

        expect(last_response.status).to eq(200)
        expect(page.current_path).to eq('/login')
      end

      it 'creates a new user' do
        params = {
          username: 'username2',
          email: 'email2',
          password: 'password2'
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
