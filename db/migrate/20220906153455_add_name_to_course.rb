class AddNameToCourse < ActiveRecord::Migration[7.0]
  def change
    change_table :courses do |t|
      t.string :name
    end
  end
end
