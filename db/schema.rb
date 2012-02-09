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

ActiveRecord::Schema.define(:version => 20100519044453) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.integer  "plagg_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", :force => true do |t|
    t.string   "name",       :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sub_category"
    t.integer  "weight",        :default => 0
  end

  add_index "categories", ["department_id"], :name => "index_categories_on_department_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "county_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["county_id"], :name => "index_cities_on_county_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "status",      :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",                   :default => 0
    t.integer  "weight1",                  :default => 0, :null => false
  end

  create_table "contents1", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "status",      :limit => 1, :default => 0, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "counties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",     :default => 0
  end

  create_table "guides", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitorings", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.string   "monitorizable_type", :null => false
    t.integer  "monitorizable_id",   :null => false
    t.boolean  "is_monitored"
    t.integer  "categorizable_id"
    t.string   "categorizable_type"
    t.integer  "group_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "monitorings", ["categorizable_id"], :name => "index_monitorings_on_categorizable_id"
  add_index "monitorings", ["categorizable_type"], :name => "index_monitorings_on_categorizable_type"
  add_index "monitorings", ["group_id"], :name => "index_monitorings_on_group_id"
  add_index "monitorings", ["monitorizable_id"], :name => "index_monitorings_on_monitorizable_id"
  add_index "monitorings", ["monitorizable_type"], :name => "index_monitorings_on_monitorizable_type"
  add_index "monitorings", ["user_id"], :name => "index_monitorings_on_user_id"

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "network_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offerings", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "plagg_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notes"
  end

  create_table "offers", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "plagg_id"
    t.datetime "received_at"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "viewed_at"
    t.datetime "accepted_at"
  end

  add_index "offers", ["receiver_id", "received_at"], :name => "index_offers_on_receiver_id_and_received_at"
  add_index "offers", ["sender_id", "sent_at"], :name => "index_offers_on_sender_id_and_sent_at"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "plaggs", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "price"
    t.boolean  "is_tradeable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.integer  "category_id"
    t.integer  "size_id"
    t.integer  "user_id"
    t.boolean  "approved"
    t.text     "body_html"
    t.string   "body"
    t.string   "brand_name"
    t.string   "brand"
  end

  add_index "plaggs", ["category_id"], :name => "index_plaggs_on_category_id"
  add_index "plaggs", ["department_id"], :name => "index_plaggs_on_department_id"
  add_index "plaggs", ["size_id"], :name => "index_plaggs_on_size_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "image_2_file_name",     :limit => 225
    t.string   "image_2_content_type",  :limit => 225
    t.string   "image_2_file_size",     :limit => 225, :null => false
    t.string   "  \timage_3_file_name", :limit => 225
    t.string   "image_3_content_type",  :limit => 225
    t.string   "image_3_file_size",     :limit => 225
    t.string   "image_4_file_name"
    t.string   "body1"
    t.text     "body1_html"
    t.string   "body"
    t.text     "body_html"
  end

  create_table "sizes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sizings", :force => true do |t|
    t.integer  "category_id"
    t.integer  "size_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sizings", ["category_id"], :name => "index_sizings_on_category_id"
  add_index "sizings", ["size_id"], :name => "index_sizings_on_size_id"

  create_table "taggings", :force => true do |t|
    t.integer  "plagg_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["plagg_id"], :name => "index_taggings_on_plagg_id"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "group"
    t.integer  "group_alias", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email_address"
    t.string   "password_hash"
    t.integer  "role"
    t.integer  "gender"
    t.text     "profile"
    t.string   "phone_number"
    t.string   "county"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "fb_email_hash"
    t.string   "confirmation_token"
    t.integer  "fb_user_id",                :limit => 8
    t.string   "security_token"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["email_address"], :name => "index_users_on_email_address"

  create_table "votes", :force => true do |t|
    t.integer  "plagg_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watchings", :force => true do |t|
    t.integer  "watcher_id"
    t.integer  "watchable_id"
    t.string   "watchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_unseen"
    t.integer  "new_unseen"
  end

  add_index "watchings", ["watcher_id"], :name => "index_watchings_on_watcher_id"

end
