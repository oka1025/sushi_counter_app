class AddWeightToGachaLists < ActiveRecord::Migration[7.0]
  def change
    add_column :gacha_lists, :weight, :integer, null: false, default: 1
  end
end
