class Portal < ApplicationRecord
  belongs_to :from_sphere, class_name: 'Sphere'
  belongs_to :to_sphere, class_name: 'Sphere'

  serialize :polygon_px, Array

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :polygon_px, :fill, :stroke, :stroke_transparency, :stroke_width, :tooltip_content, :tooltip_position, :to_sphere_id)
    end
  end
end
