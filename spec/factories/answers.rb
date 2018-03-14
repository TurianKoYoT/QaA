FactoryBot.define do
  sequence :body do |n|
    "NotVeryHelpfulAnswer#{n}"
  end
  
  factory :answer do
    body
    question
    user
    best false
  end
  
  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
