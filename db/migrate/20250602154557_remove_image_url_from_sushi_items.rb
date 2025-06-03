class RemoveImageUrlFromSushiItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :sushi_items, :image_url, :string
  end
end
