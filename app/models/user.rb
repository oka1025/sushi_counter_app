class User < ApplicationRecord
  #after_create :create_initial_counter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 7 }, format: { with: VALID_PASSWORD_REGEX }, if: :password_required?
  has_many :counters, dependent: :destroy
  has_many :sushi_items, foreign_key: :created_by_user_id, dependent: :destroy
  has_many :user_sushi_item_images, dependent: :destroy
  has_many :user_gacha_lists, dependent: :destroy
  has_many :gacha_lists, through: :user_gacha_lists

  def create_initial_counter
    counters.create!
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
