class Sphere < ApplicationRecord
  include Bitfields

  belongs_to :memory
  has_many :portals, foreign_key: 'from_sphere_id', dependent: :destroy
  has_many :from_portals, class_name: 'Portal', foreign_key: 'to_sphere_id', dependent: :destroy

  has_many :markers, dependent: :destroy

  has_one :sound_context, as: :context
  has_one :sound, through: :sound_context, source: :sound

  mount_uploader :panorama, SphereUploader
  process_in_background :panorama
  store_in_background :panorama

  def processing?
    panorama_processing
  end

  validates_presence_of :caption
  validates_presence_of :panorama

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :caption)
      json.defaultZoom default_zoom
      json.panorama panorama.url
      json.thumb panorama.thumb.url
      json.portals portals.collect { |portal| portal.to_builder.attributes! }
      json.markers markers.collect { |marker| marker.to_builder.attributes! }
      if sound.present?
        json.sound sound.to_builder
      end
    end
  end
end
