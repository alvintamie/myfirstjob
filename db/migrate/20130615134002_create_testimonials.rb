class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :position
      t.string :tmp_company_name
      t.text :contents
      t.string :grade
      t.boolean :anonymous
      t.string :status
      t.text :rejected_message
      t.integer :votes
      t.integer :company_detail_id
      t.integer :student_id
      t.timestamps
    end
    add_index :testimonials, :company_detail_id
    add_index :testimonials, :student_id
  end
end
