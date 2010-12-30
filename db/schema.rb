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

ActiveRecord::Schema.define(:version => 20101215191857) do

  create_table "activities", :force => true do |t|
    t.integer  "person_id", :default => 0, :null => false
    t.integer  "task_id", :default => 0, :null => false
    t.datetime "stopped"
    t.integer  "minutes"
    t.text     "description", :default => '', :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",   :default => false, :null => false
  end

  create_table "current_activities", :force => true do |t|
    t.integer  "person_id", :default => 0, :null => false
    t.integer  "task_id", :default => 0, :null => false
    t.datetime "started"
    t.text     "description", :default => '', :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "objectives", :force => true do |t|
    t.integer  "project_id", :default => 0, :null => false
    t.string   "name"
    t.text     "description", :default => '', :null => false
    t.string   "url"
    t.datetime "start"
    t.datetime "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",    :default => false, :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",  :default => "Pacific Time (US & Canada)", :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "client_id", :default => 0, :null => false
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",   :default => false, :null => false
  end

  create_table "rights", :force => true do |t|
    t.integer  "person_id", :default => 0, :null => false
    t.integer  "accessable_id", :default => 0, :null => false
    t.string   "accessable_type"
    t.string   "right"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "objective_id", :default => 0, :null => false
    t.string   "name"
    t.text     "description", :default => '', :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",     :default => false, :null => false
  end

end
