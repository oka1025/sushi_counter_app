class CreateSushiItemCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :sushi_item_counters do |t|
      t.references :sushi_item, null: false, foreign_key: true
      t.references :counter, null: false, foreign_key: true
      t.integer :count, null: false

      t.timestamps
    end
  end
end
