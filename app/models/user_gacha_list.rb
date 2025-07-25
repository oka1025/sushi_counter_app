class UserGachaList < ApplicationRecord
  belongs_to :user
  belongs_to :gacha_list

  before_create :generate_public_token

  private

  def generate_public_token
    self.public_token ||= SecureRandom.uuid
  end
end
