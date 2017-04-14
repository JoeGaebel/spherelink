class Sphere < ApplicationRecord
  belongs_to :memory
  has_many :portals, foreign_key: 'from_sphere_id'
  has_many :markers

  mount_uploader :panorama, SphereUploader

  def to_builder
    Jbuilder.new do |json|
      json.id id
      json.panorama panorama.url
      json.portals portals.collect { |portal| portal.to_builder.attributes! }
      json.markers markers.collect { |marker| marker.to_builder.attributes! }
    end
  end
end
