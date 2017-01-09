FactoryGirl.define do
  factory :user do
    name 'Bob'
    email 'bob@bob.bob'
    password 'bobpassword'
    password_confirmation { password || 'bobpassword' }
  end
end
