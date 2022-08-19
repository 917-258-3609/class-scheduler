class AddSubjectFkToSubjectLevel < ActiveRecord::Migration[7.0]
  def change
    change_table :subject_levels do |t|
      t.references :subject
    end
  end
end
