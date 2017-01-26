FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name }
    email { "#{ name }@example.com" }
    password 'password'
    password_confirmation { password || 'password' }
    admin { false }
    activated { true }
  end
end
