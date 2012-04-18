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

ActiveRecord::Schema.define(:version => 20120418230502) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "environments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "previous_environment_id"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "project_id"
    t.integer  "environment_id"
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.text     "template"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "maintainer"
    t.string   "email"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "kind"
    t.text     "description"
    t.string   "source"
  end

  create_table "releases", :force => true do |t|
    t.integer  "project_id"
    t.integer  "environment_id"
    t.datetime "released_at"
    t.string   "version"
    t.string   "link"
    t.text     "release_notes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
