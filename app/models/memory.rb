class Memory < ApplicationRecord
  belongs_to :user
  has_many :spheres
  attr_accessor :name
end
