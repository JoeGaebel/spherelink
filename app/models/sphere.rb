class Sphere < ApplicationRecord
  belongs_to :memory
  has_many :portals, foreign_key: 'from_sphere_id'
  has_many :markers

  has_one :sound_context, as: :context
  has_one :sound, through: :sound_context, source: :sound

  mount_uploader :panorama, SphereUploader

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.defaultZoom default_zoom
      json.panorama panorama.url
      json.portals portals.collect { |portal| portal.to_builder.attributes! }
      json.markers markers.collect { |marker| marker.to_builder.attributes! }
      if sound.present?
        json.sound sound.to_builder
      end
    end
  end
end
