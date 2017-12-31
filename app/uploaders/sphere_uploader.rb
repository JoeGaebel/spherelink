class SphereUploader < BaseUploader
  include ::CarrierWave::Backgrounder::Delay
  MAX_WIDTH = 8000

  process resize_to_limit: [MAX_WIDTH, -1]

  version :thumb do
    process resize_to_fill: [80, 80]
  end
end
