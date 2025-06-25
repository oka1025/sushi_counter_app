module GachaListsHelper
  def rarity_label(gacha_list)
    I18n.t("activerecord.attributes.gacha_list.rarity.#{gacha_list.rarity}")
  end
end