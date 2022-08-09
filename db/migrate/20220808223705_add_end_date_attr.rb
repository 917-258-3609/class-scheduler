class AddEndDateAttr < ActiveRecord::Migration[7.0]
  def change
    change_table :occurrences do |t|
      t.datetime :end_time
    end
  end
end
