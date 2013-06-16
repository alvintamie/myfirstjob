class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :location
      t.datetime :date_posted
      t.datetime :deadline
      t.datetime :start_date
      t.datetime :end_date
      t.text :responsibility
      t.text :requirements
      t.string :job_type
      t.string :industry
      t.text :job_scope
      t.integer :salary
      t.integer :number_of_hires
      t.string :status
      t.text :rejected_message
      t.integer :employer_id
      t.timestamps
    end
    add_index :jobs, :employer_id
  end
end
