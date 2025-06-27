class ChangeDefaultCoinToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :coin, from: 3, to: 5
  end
end
