class MemorySerializer < ActiveModel::Serializer
  has_many :spheres
  attributes :id, :name
end
