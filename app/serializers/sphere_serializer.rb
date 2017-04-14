class SphereSerializer < ActiveModel::Serializer
  has_many :portals, foreign_key: 'from_sphere_id'
  has_many :markers
  belongs_to :memory

  attributes :id, :panorama, :caption

  def panorama
    object.panorama.url
  end
end
