class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.decimal :fee, precision: 10, scale: 2
      t.string :location
      t.string :comment
      t.boolean :is_active 
      t.references :teacher
      t.references :subject_level
      t.timestamps
    end
  end
end
