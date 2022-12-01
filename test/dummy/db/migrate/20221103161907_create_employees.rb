class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :gender, default: 0, null: false
      t.boolean :in_portability, default: false
      t.integer :college_type, default: 0

      t.timestamps
    end
  end
end
