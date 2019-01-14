Fabricator(:movie) do
  # Faker does not have Faker::Movie.title
  name { Faker::Book.unique.title }
end
