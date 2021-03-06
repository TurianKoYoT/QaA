FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  
  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at DateTime.now
    admin false
  end
  
  factory :other_user, class: "User" do
    email
    password '123456'
    password_confirmation '123456'
    confirmed_at DateTime.now
    admin false
  end
end
