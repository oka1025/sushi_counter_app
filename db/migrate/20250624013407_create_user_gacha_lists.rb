class CreateUserGachaLists < ActiveRecord::Migration[7.0]
  def change
    create_table :user_gacha_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gacha_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
