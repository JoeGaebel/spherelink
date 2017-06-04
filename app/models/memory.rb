class Memory < ApplicationRecord
  belongs_to :user
  has_many :spheres

  has_one :sound_context, as: :context
  has_one :default_sound, through: :sound_context, source: :sound

  accepts_nested_attributes_for :spheres

  validates_presence_of :name
  validates_length_of :spheres, minimum: 1, message: ', at least one sphere is required'

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.spheres spheres.collect { |sphere| sphere.to_builder.attributes! }
      if default_sound.present?
        json.defaultSound default_sound.to_builder
      end
    end
  end
end
