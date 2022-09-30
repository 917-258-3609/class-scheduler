class AddStartTimeEndTimeToSchedule < ActiveRecord::Migration[7.0]
  def change
    change_table :schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
    end

  end
end
