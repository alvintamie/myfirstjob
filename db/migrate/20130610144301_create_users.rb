class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.string :password_recoverable
      t.string :role, :default => "member"
      t.boolean :locked, :default => false
      t.boolean :activated, :default => false
      t.string :auth_token
      t.timestamps
    end
    add_index :users, :email, :unique => true, :null => false
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :role
  end
end
