class MarkerSerializer < ActiveModel::Serializer
  include ActionView::Helpers::AssetUrlHelper

  belongs_to :sphere
  attributes :id, :image, :tooltip_content, :tooltip_position, :content,
             :x, :y, :width, :height

  def image
    image_path(object.image)
  end

  def content
    object.content.url
  end
end
