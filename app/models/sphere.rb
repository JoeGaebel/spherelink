class Sphere < ApplicationRecord
  belongs_to :memory
  has_many :portals, foreign_key: 'from_sphere_id'
  has_many :markers
end
