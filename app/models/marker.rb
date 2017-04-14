class Marker < ApplicationRecord
  belongs_to :sphere
  mount_uploader :content, MarkerUploader
end
