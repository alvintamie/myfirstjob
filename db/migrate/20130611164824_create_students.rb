class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :school
      t.integer :graduation_year
      t.integer :user_id
      t.string :majors
      t.string :nationality
      t.timestamps
    end
    add_index :students, :user_id
  end
end
