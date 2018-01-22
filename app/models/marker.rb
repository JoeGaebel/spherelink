class Marker < ApplicationRecord
  PHOTO_PLACEHOLDER = /<!--IMGHERE-->/
  DEFAULT_DIM = 32

  belongs_to :sphere

  mount_uploader :embedded_photo, EmbeddedPhotoUploader

  validates :embedded_photo, file_size: { less_than_or_equal_to: 8.megabytes }, if: :should_validate_photo

  def format_content
    html = ""

    if content.present?
      if content.match(PHOTO_PLACEHOLDER)
        if embedded_photo.url.present?
          image_html = "<img src=#{ embedded_photo.url }>"
          html += content.gsub(PHOTO_PLACEHOLDER, image_html)
        else
          html += content.gsub(PHOTO_PLACEHOLDER, '')
        end
      else
        html += content
      end
    end

    html
  end

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
      json.content format_content if format_content.present?
    end
  end

  def should_validate_photo
    embedded_photo.present?
  end
end
