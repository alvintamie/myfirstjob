# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130612150415) do

  create_table "company_details", :force => true do |t|
    t.string   "company_name"
    t.string   "company_type"
    t.string   "address"
    t.string   "number_of_employees"
    t.string   "telephone"
    t.string   "fax"
    t.string   "contact_email"
    t.text     "about"
    t.text     "award"
    t.text     "opportunities"
    t.integer  "employer_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "status"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "company_details", ["employer_id"], :name => "index_company_details_on_employer_id"

  create_table "employers", :force => true do |t|
    t.string   "company_name"
    t.string   "company_type"
    t.string   "address"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "employers", ["user_id"], :name => "index_employers_on_user_id"

  create_table "students", :force => true do |t|
    t.string   "school"
    t.integer  "graduation_year"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "students", ["user_id"], :name => "index_students_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "password_recoverable"
    t.string   "role",                 :default => "member"
    t.boolean  "locked",               :default => false
    t.boolean  "activated",            :default => false
    t.string   "auth_token"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["role"], :name => "index_users_on_role"

end
