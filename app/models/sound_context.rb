class SoundContext < ApplicationRecord
  belongs_to :context, polymorphic: true
  belongs_to :sound
end
