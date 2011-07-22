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

ActiveRecord::Schema.define(:version => 20110722224236) do

  create_table "addresses", :force => true do |t|
    t.integer  "building_number"
    t.string   "street"
    t.string   "city"
    t.integer  "zip_code"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "phone_number", :limit => 15
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.integer  "job_number"
    t.integer  "PM_id"
    t.string   "location"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "list_item_templates", :force => true do |t|
    t.string   "item_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcontractors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
