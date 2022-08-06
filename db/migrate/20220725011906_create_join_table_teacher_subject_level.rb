class CreateJoinTableTeacherSubjectLevel < ActiveRecord::Migration[7.0]
  def change
    create_join_table :teachers, :subject_levels do |t|
      t.index [:teacher_id, :subject_level_id], name: "teacher_subject"
      t.index [:teacher_id, :subject_level_id], name: "subject_teacher"
    end
  end
end
