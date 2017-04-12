class Portal < ApplicationRecord
  belongs_to :from_sphere, class_name: 'Sphere'
  belongs_to :to_sphere, class_name: 'Sphere'

  serialize :polygon_px, Array
end
