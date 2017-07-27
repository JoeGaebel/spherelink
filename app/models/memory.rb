class Memory < ApplicationRecord
  belongs_to :user
  has_many :spheres, dependent: :destroy

  has_one :sound_context, as: :context
  has_one :default_sound, through: :sound_context, source: :sound

  accepts_nested_attributes_for :spheres

  validates_presence_of :name
  validate :at_least_one_sphere

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.spheres spheres.collect { |sphere| sphere.to_builder.attributes! }.order(:created_at)
      if default_sound.present?
        json.defaultSound default_sound.to_builder
      end
    end
  end

  private

  def at_least_one_sphere
    if self.persisted? && spheres.length < 1
      errors.add :spheres, 'at least one sphere must be present'
    end
  end
end
