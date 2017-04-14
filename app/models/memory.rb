class Memory < ApplicationRecord
  belongs_to :user
  has_many :spheres

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.spheres spheres.collect { |sphere| sphere.to_builder.attributes! }
    end
  end
end
