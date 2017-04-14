class PortalSerializer < ActiveModel::Serializer
  belongs_to :sphere
  attributes :id, :polygon_px, :fill, :stroke, :stroke_transparency, :stroke_width,
             :tooltip_content, :tooltip_position, :to_sphere_id
end
