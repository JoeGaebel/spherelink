class Sound < ApplicationRecord
  mount_uploader :file, SoundUploader

  has_many :sound_contexts, as: :sound
  has_many :memories, through: :sound_contexts, source: :context, source_type: 'Memory'
  has_many :spheres, through: :sound_contexts, source: :context, source_type: 'Sphere'

  def to_builder
    Jbuilder.new do |json|
      json.(self, :name, :volume, :loops)
      json.id "sound-#{id}"
      json.url file.url
    end
  end
end
