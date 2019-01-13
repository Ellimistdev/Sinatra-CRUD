Fabricator(:review) do
  reviewer
  movie
  content { Faker::Lorem.sentence }
  rating { rand(1..5) }
end