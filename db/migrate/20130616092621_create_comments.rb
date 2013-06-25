class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :testimonial_id
      t.integer :interview_id
      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :testimonial_id
    add_index :comments, :interview_id
  end
end
