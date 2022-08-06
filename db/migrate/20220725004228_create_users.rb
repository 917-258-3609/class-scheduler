class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.decimal :balance, precision: 10, scale: 2
      t.references :accountable, polymorphic: true 
      t.boolean :is_active 
      t.timestamps
    end
  end
end
