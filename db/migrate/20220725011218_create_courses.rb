class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.decimal :fee, precision: 10, scale: 2
      t.string :location
      t.string :comment
      t.boolean :is_active 
      t.timestamps
    end
  end
end
