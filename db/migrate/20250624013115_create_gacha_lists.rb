class CreateGachaLists < ActiveRecord::Migration[7.0]
  def change
    create_table :gacha_lists do |t|
      t.string :name, null: false
      t.string :rarity, null: false

      t.timestamps
    end
  end
end
