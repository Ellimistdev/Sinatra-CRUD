Fabricator(:movie) do
  name { Faker::Book.unique.title}
end