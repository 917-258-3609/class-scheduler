class RemoveIceCubeBFromOccurrences < ActiveRecord::Migration[7.0]
  def change
    remove_column :occurrences, :ice_cube_b
    remove_column :occurrences, :days
    remove_column :occurrences, :count
    remove_column :occurrences, :period
    remove_column :occurrences, :duration
  end
end
