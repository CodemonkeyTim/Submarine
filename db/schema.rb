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

ActiveRecord::Schema.define(:version => 20110714220132) do

  create_table "contact_people", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "phone_number"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_partner_partners", :force => true do |t|
    t.integer  "job_number"
    t.integer  "partner_id"
    t.integer  "p_partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_partners", :force => true do |t|
    t.integer  "job_number"
    t.integer  "partner_id"
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
  end

  create_table "list_items", :force => true do |t|
    t.string   "item_data"
    t.integer  "job_number"
    t.integer  "partner_id"
    t.boolean  "is_done"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "partner_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
