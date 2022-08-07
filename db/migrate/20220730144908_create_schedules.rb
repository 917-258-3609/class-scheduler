class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :scheduleable, polymorphic: true
      t.timestamps
    end
  end
end
