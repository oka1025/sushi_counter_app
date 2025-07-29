class AddPublicTokenToUserGachaLists < ActiveRecord::Migration[7.0]
  def change
    change_table :user_gacha_lists, bulk: true do |t|
      t.string :public_token
      t.index :public_token, unique: true
    end
  end
end
