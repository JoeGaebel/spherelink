class EmbeddedPhotoUploader < BaseUploader
  include ::CarrierWave::Backgrounder::Delay
  process :quality => 75
  process resize_to_limit: [1400, -1]
end
