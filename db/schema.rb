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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170430230323) do

  create_table "markers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image"
    t.string   "tooltip_content"
    t.string   "tooltip_position",               default: "right bottom"
    t.text     "content",          limit: 65535
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.integer  "sphere_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["sphere_id"], name: "index_markers_on_sphere_id", using: :btree
  end

  create_table "memories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", limit: 65535
    t.boolean  "private",                   default: false
    t.index ["user_id"], name: "index_memories_on_user_id", using: :btree
  end

  create_table "microposts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree
    t.index ["user_id"], name: "index_microposts_on_user_id", using: :btree
  end

  create_table "portals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "polygon_px",          limit: 65535
    t.string   "fill",                                                        default: "points"
    t.string   "stroke",                                                      default: "#ff0032"
    t.integer  "stroke_transparency",                                         default: 80
    t.integer  "stroke_width",                                                default: 2
    t.string   "tooltip_content"
    t.string   "tooltip_position",                                            default: "right bottom"
    t.integer  "from_sphere_id"
    t.integer  "to_sphere_id"
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.decimal  "fov_lat",                           precision: 18, scale: 17, default: "0.0"
    t.decimal  "fov_lng",                           precision: 18, scale: 17, default: "0.0"
  end

  create_table "relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  end

  create_table "sound_contexts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "context_type"
    t.integer "context_id"
    t.integer "sound_id"
    t.index ["context_type", "context_id"], name: "index_sound_contexts_on_context_type_and_context_id", using: :btree
    t.index ["sound_id"], name: "index_sound_contexts_on_sound_id", using: :btree
  end

  create_table "sounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "volume"
    t.string   "name"
    t.string   "file"
    t.integer  "loops"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spheres", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "panorama"
    t.string   "caption"
    t.integer  "memory_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "default_zoom", default: 50
    t.index ["memory_id"], name: "index_spheres_on_memory_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "microposts", "users"
end
