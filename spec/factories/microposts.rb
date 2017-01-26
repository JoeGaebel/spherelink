FactoryGirl.define do
  factory :micropost do
    content { Faker::Hipster.sentence(3, false, 4) }
    user
  end
end
