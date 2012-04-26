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

ActiveRecord::Schema.define(:version => 20120330172820) do

  create_table "annals", :force => true do |t|
    t.string   "semester"
    t.integer  "year"
    t.string   "type"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "annals", ["course_id"], :name => "index_annals_on_course_id"

  create_table "answers", :force => true do |t|
    t.string   "content"
    t.integer  "poll_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "answers", ["poll_id"], :name => "index_answers_on_poll_id"

  create_table "assos", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "email"
    t.text     "description"
    t.integer  "owner_id"
    t.integer  "image_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "assos", ["owner_id"], :name => "index_assos_on_owner_id"

  create_table "assos_events", :force => true do |t|
    t.integer  "asso_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "assos_events", ["asso_id"], :name => "index_assos_events_on_asso_id"
  add_index "assos_events", ["event_id"], :name => "index_assos_events_on_event_id"

  create_table "carpools", :force => true do |t|
    t.text     "description"
    t.string   "departure"
    t.string   "arrival"
    t.datetime "date"
    t.boolean  "is_driver"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "carpools", ["user_id"], :name => "index_carpools_on_user_id"

  create_table "classifieds", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "price"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "classifieds", ["user_id"], :name => "index_classifieds_on_user_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "documents", :force => true do |t|
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.string   "type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "documents", ["documentable_id", "documentable_type"], :name => "index_documents_on_documentable_id_and_documentable_type"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "owner_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "events", ["owner_id"], :name => "index_events_on_owner_id"

  create_table "events_users", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "events_users", ["event_id"], :name => "index_events_users_on_event_id"
  add_index "events_users", ["user_id"], :name => "index_events_users_on_user_id"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "is_moderated", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "news", ["event_id"], :name => "index_news_on_event_id"
  add_index "news", ["user_id"], :name => "index_news_on_user_id"

  create_table "polls", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "polls", ["user_id"], :name => "index_polls_on_user_id"

  create_table "preferences", :force => true do |t|
    t.string   "locale"
    t.string   "quote_type"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "preferences", ["user_id"], :name => "index_preferences_on_user_id"

  create_table "profiles", :force => true do |t|
    t.string   "utt_address"
    t.string   "parents_address"
    t.string   "surname"
    t.string   "once"
    t.integer  "utt_id"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "level"
    t.string   "specialization"
    t.string   "role"
    t.string   "phone"
    t.string   "room"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "image_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "owner_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "projects", ["owner_id"], :name => "index_projects_on_owner_id"

  create_table "projects_users", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projects_users", ["project_id"], :name => "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id"], :name => "index_projects_users_on_user_id"

  create_table "quotes", :force => true do |t|
    t.string   "content"
    t.string   "tag"
    t.string   "author"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "asso_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["asso_id"], :name => "index_roles_on_asso_id"

  create_table "roles_users", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "timesheets", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "week"
    t.string   "room"
    t.string   "category"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "timesheets", ["course_id"], :name => "index_timesheets_on_course_id"

  create_table "timesheets_users", :force => true do |t|
    t.integer  "timesheet_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "timesheets_users", ["timesheet_id"], :name => "index_timesheets_users_on_timesheet_id"
  add_index "timesheets_users", ["user_id"], :name => "index_timesheets_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "perishable_token"
    t.datetime "perishable_token_date"
    t.string   "auth_token"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "votes", :force => true do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "votes", ["answer_id"], :name => "index_votes_on_answer_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

  create_table "wikis", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "role_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wikis", ["role_id"], :name => "index_wikis_on_role_id"

end
