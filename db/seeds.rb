User.create!({
  name:  'Joe',
  email: 'joe@joegaebel.com',
  password:              'password',
  password_confirmation: 'password',
  admin: true,
  activated: true,
  activated_at: Time.zone.now
})

100.times do |n|
  User.create!({
    name: Faker::Name.name,
    email: "example-#{n+1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    activated: true,
    activated_at: Time.zone.now
  })
end

users = User.order(:created_at).take(6)
50.times do
  users.each do |user|
    content = Faker::Hipster.sentence(4, false, 4)
    user.microposts.create!(content: content)
  end
end
