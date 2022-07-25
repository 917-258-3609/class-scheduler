class CreateWeeklySchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_schedules do |t|
      t.boolean :is_negative

      t.timestamps
    end
  end
end
