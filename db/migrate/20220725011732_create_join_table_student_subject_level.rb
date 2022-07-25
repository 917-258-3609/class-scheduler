class CreateJoinTableStudentSubjectLevel < ActiveRecord::Migration[7.0]
  def change
    create_join_table :students, :subject_levels do |t|
      t.index [:student_id, :subject_level_id]
    end
  end
end
