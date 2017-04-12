class Marker < ApplicationRecord
  belongs_to :sphere
  attr_accessor :image, :tooltip_content, :tooltip_position,
                  :content, :x, :y, :width, :height
end
