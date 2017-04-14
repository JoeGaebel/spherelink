USERS_COUNT = 15
POSTS_COUNT = 5

joe = User.create!({
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

puts "Creating memory stuff"

memory = Memory.create!({
  user: joe,
  name: "Joe's Childhood Home"
})

livingroom_sphere = Sphere.create!({
  memory: memory,
  panorama: File.open("#{Rails.root}/app/assets/images/livingroom.jpg"),
  caption: 'living room!'
})

kitchen_sphere = Sphere.create!({
  memory: memory,
  panorama: File.open("#{Rails.root}/app/assets/images/kitchen.jpg"),
  caption: 'kitchen!'
})

Marker.create!({
  sphere: kitchen_sphere,
  image: 'pin2.png',
  tooltip_content: 'Look at joes face',
  content: File.open("#{Rails.root}/app/assets/images/joesface.jpg"),
  x: 2068,
  y: 1225,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: kitchen_sphere,
  image: 'pin2.png',
  tooltip_content: 'cool fridge photo',
  content: File.open("#{Rails.root}/app/assets/images/fridge.jpg"),
  x: 8546,
  y: 745,
  width: 32,
  height: 32
})

Portal.create!({
  polygon_px: [4042,289,4402,236,4507,1338,4069,1343],
  from_sphere: livingroom_sphere,
  to_sphere: kitchen_sphere,
  tooltip_content: 'Go to the kitchen!'
})

Portal.create!({
  polygon_px: [8950,302,555,280,658,848,255,996,313,1596,9014,1666,8958,302],
  from_sphere: kitchen_sphere,
  to_sphere: livingroom_sphere,
  tooltip_content: 'Go to the livingroom!'
})

