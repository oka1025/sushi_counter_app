class AddPublicTokenToUserGachaLists < ActiveRecord::Migration[7.0]
  def change
    add_column :user_gacha_lists, :public_token, :string
    add_index :user_gacha_lists, :public_token, unique: true
  end
end
