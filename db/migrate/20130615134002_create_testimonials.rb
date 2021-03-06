class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :position
      # t.datetime :start_date
      # t.datetime :end_date
      t.string :experience_level
      t.string :last_working_month
      t.integer :last_working_year
      t.boolean :still_employer
      t.string :tmp_company_name
      t.text :contents
      t.string :grade
      t.boolean :anonymous
      t.string :status
      t.text :rejected_message
      t.integer :votes, :default => 0
      t.text :downvotes
      t.text :upvotes
      t.integer :company_detail_id
      t.integer :student_id
      t.string :other
      t.timestamps
    end
    add_index :testimonials, :company_detail_id
    add_index :testimonials, :student_id
  end
end
