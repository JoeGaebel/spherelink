class Portal < ApplicationRecord
  belongs_to :from_sphere, class_name: 'Sphere'
  belongs_to :to_sphere, class_name: 'Sphere'

  serialize :polygon_px, Array

  def hex2rgba(hex, opacity)
    hex = hex.sub!('#','')
    r = Integer(hex.slice(0, hex.length/3), 16)
    g = Integer(hex.slice(hex.length/3, 2*hex.length/3), 16)
    b = Integer(hex.slice(2*hex.length/3, 3*hex.length/3), 16)

    "rgba(#{r}, #{g}, #{b}, #{opacity/100.0})"
  end

  def to_builder
    Jbuilder.new do |json|
      json.(self, :polygon_px, :fov_lat, :fov_lng)
      json.id "portal-#{id}"
      json.to_sphere_id to_sphere_id
      json.from_sphere_id from_sphere_id
      json.svgStyle do
        json.key_format! -> (key){ key.sub('_', '-') }
        json.fill "url(##{fill})"
        json.stroke hex2rgba(stroke, stroke_transparency)
        json.stroke_width "#{stroke_width}px"
      end

      if tooltip_content.present?
        json.tooltip do
          json.content tooltip_content
          json.position tooltip_position
        end
      end
    end
  end
end
