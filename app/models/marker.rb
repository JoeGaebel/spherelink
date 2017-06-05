class Marker < ApplicationRecord
  include ActionView::Helpers::AssetTagHelper
  DEFAULT_DIM = 32

  belongs_to :sphere

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
      json.content content if content.present?
    end
  end
end
