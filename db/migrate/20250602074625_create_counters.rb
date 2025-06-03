class CreateCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :counters do |t|
      t.date :eaten_at, null: false
      t.string :store_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
