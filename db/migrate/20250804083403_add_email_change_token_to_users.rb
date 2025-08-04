class AddEmailChangeTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_change_token, :string
    add_index :users, :email_change_token, unique: true
    add_column :users, :email_change_sent_at, :datetime
  end
end
