class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.string :position
      t.string :tmp_company_name
      t.text :contents
      t.datetime :interview_date
      t.boolean :anonymous
      t.string :status
      t.string :offer_status
      t.text :rejected_message
      t.integer :votes, :default => 0
      t.text :downvotes
      t.text :upvotes
      t.integer :company_detail_id
      t.integer :student_id
      t.timestamps
    end
    add_index :interviews, :company_detail_id
    add_index :interviews, :student_id
  end
end


