class CreateOccurrences < ActiveRecord::Migration[7.0]
  def change
    create_table :occurrences do |t|
      t.boolean :is_negative
      t.time :start_time
      t.interval :duration
      t.interval :period
      t.references :schedule

      t.timestamps
    end
  end
end
