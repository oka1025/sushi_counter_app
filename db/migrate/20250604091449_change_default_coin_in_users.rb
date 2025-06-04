class ChangeDefaultCoinInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :coin, from: nil, to: 3
  end
end
