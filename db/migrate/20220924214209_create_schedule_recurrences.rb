class CreateScheduleRecurrences < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_recurrences do |t|
      t.interval :start_time_from_bow
      t.interval :end_time_from_bow
      t.references :schedule

      t.timestamps
    end
  end
end
