User.create!({
  name:  'Joe',
  email: 'joe@joegaebel.com',
  password:              'password',
  password_confirmation: 'password',
  admin: true
})

100.times do |n|
  User.create!({
    name: Faker::Name.name,
    email: "example-#{n+1}@example.com",
    password: 'password',
    password_confirmation: 'password'
  })
end
