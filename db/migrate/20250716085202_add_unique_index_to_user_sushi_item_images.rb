class AddUniqueIndexToUserSushiItemImages < ActiveRecord::Migration[7.0]
  def change
    add_index :user_sushi_item_images, [:user_id, :sushi_item_id], unique: true
  end
end
