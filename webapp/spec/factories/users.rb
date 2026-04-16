FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { "#{ name }@example.com" }
    password 'password'
    password_confirmation { password || 'password' }
    admin { false }
    confirmed_at { DateTime.now() }
  end
end
