class Sphere < ApplicationRecord
  belongs_to :memory
  has_many :portals
  has_many :markers

  attr_accessor :panorma, :caption
end
