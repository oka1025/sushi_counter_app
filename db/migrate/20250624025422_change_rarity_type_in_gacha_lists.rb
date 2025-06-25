class ChangeRarityTypeInGachaLists < ActiveRecord::Migration[7.0]
  def change
    change_column :gacha_lists, :rarity, :integer, using: 'rarity::integer', default: 0, null: false
  end
end
