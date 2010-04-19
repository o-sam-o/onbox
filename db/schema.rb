# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100417042758) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_video_contents", :id => false, :force => true do |t|
    t.integer "video_content_id"
    t.integer "genre_id"
  end

  add_index "genres_video_contents", ["genre_id"], :name => "index_genres_video_contents_on_genre_id"
  add_index "genres_video_contents", ["video_content_id"], :name => "index_genres_video_contents_on_video_content_id"

  create_table "media_folders", :force => true do |t|
    t.string   "location"
    t.boolean  "scan"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tv_episodes", :force => true do |t|
    t.string   "title"
    t.string   "plot"
    t.integer  "series"
    t.integer  "episode"
    t.date     "date"
    t.integer  "video_file_reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tv_show_id"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["updated_at"], :name => "index_user_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "video_contents", :force => true do |t|
    t.string   "name"
    t.integer  "year"
    t.string   "plot"
    t.string   "state"
    t.string   "imdb_id"
    t.string   "language"
    t.string   "tag_line"
    t.integer  "runtime"
    t.date     "release_date"
    t.string   "director"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "video_file_properties", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "order"
    t.integer  "video_file_reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
  end

  create_table "video_file_references", :force => true do |t|
    t.string   "raw_name"
    t.string   "location"
    t.boolean  "on_disk"
    t.integer  "media_folder_id"
    t.integer  "video_content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size"
    t.string   "format"
  end

  create_table "video_posters", :force => true do |t|
    t.string   "size"
    t.string   "location"
    t.integer  "height"
    t.integer  "width"
    t.integer  "video_content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
