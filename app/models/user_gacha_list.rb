class UserGachaList < ApplicationRecord
  belongs_to :user
  belongs_to :gacha_list
end
