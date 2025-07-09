class AddNameKanaToSushiItems < ActiveRecord::Migration[7.0]
  def change
    add_column :sushi_items, :name_kana, :string
  end
end
