class Marker < ApplicationRecord
  include ActionView::Helpers::AssetTagHelper

  belongs_to :sphere
  mount_uploader :content, MarkerUploader

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :x, :y, :width, :height)
      json.id "marker-#{id}"
      json.image ActionController::Base.helpers.image_path(image)
      if tooltip_content.present?
        json.tooltip do
          json.content tooltip_content
          json.position tooltip_position
        end
      end
      json.content image_tag(content.url, style: "width: 100%") if content.url.present?
    end
  end
end
