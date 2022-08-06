class CreateOccurrences < ActiveRecord::Migration[7.0]
  def change
    create_table :occurrences do |t|
      t.datetime :start_time
      t.integer :count
      t.interval :period
      t.interval :duration 
      t.references :schedule

      t.timestamps
    end
  end
end
