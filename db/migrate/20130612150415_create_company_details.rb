class CreateCompanyDetails < ActiveRecord::Migration
  def change
    create_table :company_details do |t|
      t.string :company_name
      t.string :company_type
      t.string :company_industry
      t.string :address
      t.string :number_of_employees
      t.string :address
      t.string :telephone
      t.string :fax
      t.string :contact_email
      t.text :about
      t.text :award
      t.text :opportunities
      t.text :rejected_message
      t.attachment :image
      t.string :status
      t.integer :employer_id
      t.integer :student_id
      t.boolean :featured
      t.timestamps
    end
    add_index :company_details, :student_id
    add_index :company_details, :employer_id
  end
end
