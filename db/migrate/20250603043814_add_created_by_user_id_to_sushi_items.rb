class AddCreatedByUserIdToSushiItems < ActiveRecord::Migration[7.0]
  def change
    add_column :sushi_items, :created_by_user_id, :integer
  end
end
