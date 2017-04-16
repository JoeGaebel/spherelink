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

# USERS_COUNT.times do |n|
#   User.create!({
#     name: Faker::Name.name,
#     email: "example-#{n+1}@example.com",
#     password: 'password',
#     password_confirmation: 'password',
#     activated: true,
#     activated_at: Time.zone.now
#   })
# end

# users = User.order(:created_at).take(USERS_COUNT/3)
# POSTS_COUNT.times do
#   users.each do |user|
#     content = Faker::Hipster.sentence(4, false, 4)
#     user.microposts.create!(content: content)
#   end
# end
#
# users = User.all
# user  = users.first
# following = users[2..USERS_COUNT]
# followers = users[3..USERS_COUNT]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }

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


boat = Memory.create!({
  user: joe,
  name: "Joe's Boat"
})

marina = Sphere.create!({
  memory: boat,
  panorama: File.open("#{Rails.root}/app/assets/images/marina.jpg"),
  caption: 'Marina',
  default_zoom: 100
})

boat_livingroom = Sphere.create!({
  memory: boat,
  panorama: File.open("#{Rails.root}/app/assets/images/boat_livingroom.jpg"),
  caption: 'Boat Livingroom',
  default_zoom: 78
})

boat_bed = Sphere.create!({
  memory: boat,
  panorama: File.open("#{Rails.root}/app/assets/images/boat_bed.jpg"),
  caption: 'Boat Bedroom',
  default_zoom: 36
})

night_time = Sphere.create!({
  memory: boat,
  panorama: File.open("#{Rails.root}/app/assets/images/boat_night.jpg"),
  default_zoom: 75
})

Portal.create!({
  polygon_px: [10132, 1403, 9498, 1131, 9281, 1007, 9073, 945, 8979, 928, 8737, 906, 8558, 919, 8424, 972, 8420, 1064, 8285, 1054, 8293, 1360, 8442, 1564, 8767, 1678, 9736, 1986, 10135, 1439],
  from_sphere: marina,
  to_sphere: boat_livingroom,
  fov_lat: -0.44164038991889765,
  fov_lng: 0.07131935408296552,
  tooltip_content: 'Welcome aboard!'
})

Portal.create!({
  polygon_px: [4426, 1188, 4930, 1198, 4966, 1932, 4381, 1907],
  from_sphere: boat_livingroom,
  to_sphere: boat_bed,
  fov_lat: -0.2149931464977397,
  fov_lng: 0.04682678441209071,
  tooltip_content: 'Check out that boat bed!'
})

Portal.create!({
  polygon_px: [1685, -8, 5132, -22, 4488, 1092, 2836, 968],
  from_sphere: boat_bed,
  to_sphere: marina,
  fov_lat: -0.01934385578648512,
  fov_lng: 0.6276086446264931,
  tooltip_content: 'Go back to the marina'
})

Portal.create!({
  polygon_px: [2844, 1518, 3050, 1549, 3046, 1786, 2798, 1773],
  stroke_transparency: 30,
  from_sphere: boat_livingroom,
  to_sphere: night_time,
  fov_lat: -0.30214935245693164,
  fov_lng: 0.17226333918505282,
  tooltip_content: 'Turn the light on'
})

Portal.create!({
  polygon_px: [3825, 1037, 4102, 1061, 4069, 1369, 3753, 1337],
  stroke_transparency: 30,
  from_sphere: night_time,
  to_sphere: boat_livingroom,
  fov_lat: -0.6267388220839005,
  fov_lng: 0.16397512279941956,
  tooltip_content: 'Go back to day time'
})

Marker.create!({
  sphere: boat_livingroom,
  image: 'back.jpg',
  x: -4605,
  y: 472,
  width: 500,
  height: 450
})

Marker.create!({
  sphere: night_time,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/marina_night.jpg"),
  x: 6815,
  y: 579,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: marina,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/joe_sail.jpg"),
  x: 8991,
  y: 632,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: boat_bed,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/books.jpg"),
  x: 6658,
  y: 2894,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: boat_bed,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/dollars.jpg"),
  x: 2298,
  y: 2651,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: night_time,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/marina_night2.jpg"),
  x: 3032,
  y: 374,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: boat_livingroom,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/drawer.jpg"),
  x: 8024,
  y: 4747,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: night_time,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/golden_gate_night.jpg"),
  x: 6383,
  y: 638,
  width: 32,
  height: 32
})

Marker.create!({
  sphere: night_time,
  image: 'pin2.png',
  content: File.open("#{Rails.root}/app/assets/images/boat_bed_night.jpg"),
  x: 5308,
  y: 1230,
  width: 32,
  height: 32
})

sail_sound = Sound.create!({
  volume: 30,
  file: File.open("#{Rails.root}/app/assets/sounds/sail.mp3"),
  loops: 100,
  name: 'sail'
})

sad_sound = Sound.create!({
  volume: 30,
  file: File.open("#{Rails.root}/app/assets/sounds/as_you_found_me.mp3"),
  loops: 100,
  name: 'as_you_found_me'
})


boat.default_sound = sail_sound
night_time.sound = sad_sound
