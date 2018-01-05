class Memory < ApplicationRecord
  belongs_to :user
  has_many :spheres, dependent: :destroy

  has_one :sound_context, as: :context
  has_one :default_sound, through: :sound_context, source: :sound

  accepts_nested_attributes_for :spheres

  validates_presence_of :name

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :private)
      json.spheres spheres.order(:created_at).collect { |sphere| sphere.to_builder.attributes! }
      if default_sound.present?
        json.defaultSound default_sound.to_builder
      end
    end
  end
end
