FactoryBot.define do
  sequence :title do |n|
    "INteresting_title#{n}"
  end
  
  factory :question do
    title
    body 'QuestionBody'
    user
  end
  
  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
