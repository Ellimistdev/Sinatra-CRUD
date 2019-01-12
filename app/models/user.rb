class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews
  has_many :reviewed_movies, through: :reviews, source: :movie
end
