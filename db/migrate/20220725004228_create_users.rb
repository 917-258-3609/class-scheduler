class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.decimal :balance, precision: 5, scale: 2
      t.reference :accountable, polymorphic: true 

      t.timestamps
    end
  end
end
