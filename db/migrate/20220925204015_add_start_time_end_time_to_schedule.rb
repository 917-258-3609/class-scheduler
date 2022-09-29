class AddStartTimeEndTimeToSchedule < ActiveRecord::Migration[7.0]
  def change
    change_table :schedule do |t|
      t.datetime :start_time
      t.datetime :end_time
    end

  end
end
