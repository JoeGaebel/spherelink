class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  MINIMUM_PASSWORD_LENGTH = 8
  MAXIMUM_PASSWORD_LENGTH = 128

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :omniauthable, :lockable,
         password_length: MINIMUM_PASSWORD_LENGTH..MAXIMUM_PASSWORD_LENGTH

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_many :memories, dependent: :destroy
  has_many :spheres, through: :memories
end
