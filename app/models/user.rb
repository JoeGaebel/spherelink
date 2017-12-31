class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :omniauthable, :lockable

  validates :name, presence: true, length: { maximum: 50 }

  has_many :memories, dependent: :destroy
  has_many :spheres, through: :memories
end
