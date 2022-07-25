class CreateWeeklyIntervals < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_intervals do |t|
      t.integer :day_of_week
      t.time :start_time
      t.integer :duration

      t.timestamps
    end
  end
end
