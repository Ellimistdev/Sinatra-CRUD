Fabricator(:review) do
  reviewer do
    # as either an existing user or newly generated user
    existing_users = User.all if User.any? && [true, false].sample
    existing_users ? existing_users.sample : Fabricate(:reviewer)
  end
  movie do
    # randomly review an existing movie or newly generated movie
    existing_movies = Movie.all if Movie.any? && [true, false].sample
    existing_movies ? existing_movies.sample : Fabricate(:movie)
  end
  content { Faker::Lorem.sentence }
  rating { rand(1..5) }
end
