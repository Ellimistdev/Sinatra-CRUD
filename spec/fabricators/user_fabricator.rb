Fabricator(:reviewer, from: :user) do
  username { Faker::Name.unique.name }
  email { "#{Faker::Lorem.word}@email.com" }
  password { Faker::Lorem.word }
end
