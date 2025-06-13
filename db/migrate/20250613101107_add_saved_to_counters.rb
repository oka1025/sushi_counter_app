class AddSavedToCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :counters, :saved, :boolean
  end
end
