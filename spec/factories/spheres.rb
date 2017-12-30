FactoryGirl.define do
  factory :sphere do
    memory
    guid { SecureRandom.hex }
    processing_bits Sphere::MAX_PROCESSING_BIT
    caption { Faker::Space.planet }
    panorama { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'rails.png'), 'image/jpeg') }
  end
end
