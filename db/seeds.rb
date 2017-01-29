USERS_COUNT = 15
POSTS_COUNT = 5

User.create!({
  name:  'Joe',
  email: 'joe@joegaebel.com',
  password:              'password',
  password_confirmation: 'password',
  admin: true,
  activated: true,
  activated_at: Time.zone.now
})

USERS_COUNT.times do |n|
  User.create!({
    name: Faker::Name.name,
    email: "example-#{n+1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    activated: true,
    activated_at: Time.zone.now
  })
end

users = User.order(:created_at).take(USERS_COUNT/3)
POSTS_COUNT.times do
  users.each do |user|
    content = Faker::Hipster.sentence(4, false, 4)
    user.microposts.create!(content: content)
  end
end

users = User.all
user  = users.first
following = users[2..USERS_COUNT]
followers = users[3..USERS_COUNT]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
