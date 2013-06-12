class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :company_name
      t.string :company_type
      t.string :address
      t.integer :user_id
      t.timestamps
    end
    add_index :employers, :user_id
  end
end
