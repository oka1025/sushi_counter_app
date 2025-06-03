class CreateSushiItems < ActiveRecord::Migration[7.0]
  def change
    create_table :sushi_items do |t|
      t.string :name, null: false
      t.references :category, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
