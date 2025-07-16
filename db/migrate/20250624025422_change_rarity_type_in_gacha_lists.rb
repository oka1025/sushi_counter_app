class ChangeRarityTypeInGachaLists < ActiveRecord::Migration[7.0]
  def up
    change_column :gacha_lists, :rarity, :integer, using: 'rarity::integer', default: 0, null: false
  end

  def down
    change_column :gacha_lists, :rarity, :string
  end
end
