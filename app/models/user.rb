class User < ApplicationRecord
  #after_create :create_initial_counter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:google_oauth2]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 7 }, format: { with: VALID_PASSWORD_REGEX }, if: :password_required?
  has_many :counters, dependent: :destroy
  has_many :sushi_items, foreign_key: :created_by_user_id, dependent: :destroy, inverse_of: :created_by_user
  has_many :user_sushi_item_images, dependent: :destroy
  has_many :user_gacha_lists, dependent: :destroy
  has_many :gacha_lists, through: :user_gacha_lists
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_sushi_items, through: :bookmarks, source: :sushi_item

  def create_initial_counter
    counters.create!
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    if user.new_record?
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
      user.save(validate: false) # バリデーション無視で保存
    end

    user
  end

  def send_email_change_confirmation(new_email)
    self.unconfirmed_email = new_email
    self.email_change_token = SecureRandom.urlsafe_base64
    self.email_change_sent_at = Time.current
    save(validate: false)  # 新しいemailをまだ有効化していないためvalidateはスキップ

    UserMailer.email_change_confirmation(self).deliver_later
  end

  def confirm_email_change(token)
    return false unless self.email_change_token == token
    return false if email_change_sent_at.nil? || email_change_sent_at < 2.hours.ago

    self.email = self.unconfirmed_email
    self.unconfirmed_email = nil
    self.email_change_token = nil
    self.email_change_sent_at = nil
    save(validate: false)
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
