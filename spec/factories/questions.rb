FactoryBot.define do
  factory :question do
    title Faker::StarWars.quote
    body Faker::Lorem.paragraph
  end
end
