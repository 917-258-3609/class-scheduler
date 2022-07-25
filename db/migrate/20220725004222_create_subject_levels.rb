class CreateSubjectLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_levels do |t|
      t.string :subject
      t.integer :level

      t.timestamps
    end
  end
end
