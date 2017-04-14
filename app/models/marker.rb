class Marker < ApplicationRecord
  include ActionView::Helpers::AssetUrlHelper

  belongs_to :sphere
  mount_uploader :content, MarkerUploader

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :tooltip_content, :tooltip_position, :x, :y, :width, :height)
      json.image image_url(image)
      json.content content.url
    end
  end
end
