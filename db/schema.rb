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

ActiveRecord::Schema.define(:version => 20111004031027) do

  create_table "addresses", :force => true do |t|
    t.integer  "partner_id"
    t.integer  "building_number"
    t.string   "street"
    t.string   "city"
    t.integer  "zip_code"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "job_id"
    t.integer  "parent_id"
    t.integer  "partner_id"
    t.integer  "partner_type"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id"
  end

  create_table "checklist_items", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "cli_type"
    t.string   "item_data"
    t.integer  "state"
    t.integer  "sleep_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", :force => true do |t|
    t.integer  "partner_id"
    t.string   "name"
    t.string   "title"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global"
  end

  create_table "jobs", :force => true do |t|
    t.string   "job_number"
    t.string   "location"
    t.string   "name"
    t.integer  "project_manager_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "project_engineer_id"
  end

  create_table "list_item_templates", :force => true do |t|
    t.string   "item_data"
    t.integer  "item_type"
    t.integer  "rep_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.string   "target_type"
    t.string   "target_name"
    t.string   "action"
    t.string   "notes"
    t.string   "date"
    t.string   "time"
    t.integer  "loggable_id"
    t.string   "loggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "job_id"
    t.integer  "number"
    t.datetime "overdue_on"
    t.boolean  "received"
    t.datetime "received_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_engineers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_managers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
