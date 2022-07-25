class CreateSemesterSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :semester_schedules do |t|
      t.date :starting_date

      t.timestamps
    end
  end
end
