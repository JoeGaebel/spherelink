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

ActiveRecord::Schema.define(version: 20180121224714) do

  create_table "delayed_jobs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "markers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.string "tooltip_content"
    t.string "tooltip_position", default: "right bottom"
    t.text "content"
    t.integer "x"
    t.integer "y"
    t.integer "width"
    t.integer "height"
    t.integer "sphere_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.string "embedded_photo"
    t.boolean "embedded_photo_processing", default: false, null: false
    t.index ["guid"], name: "index_markers_on_guid"
    t.index ["sphere_id"], name: "index_markers_on_sphere_id"
  end

  create_table "memories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.boolean "private", default: false
    t.index ["user_id"], name: "index_memories_on_user_id"
  end

  create_table "microposts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "portals", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "polygon_px"
    t.string "fill", default: "points"
    t.string "stroke", default: "#ff0032"
    t.integer "stroke_transparency", default: 80
    t.integer "stroke_width", default: 2
    t.string "tooltip_content"
    t.string "tooltip_position", default: "right bottom"
    t.integer "from_sphere_id"
    t.integer "to_sphere_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fov_lat", precision: 18, scale: 17, default: "0.0"
    t.decimal "fov_lng", precision: 18, scale: 17, default: "0.0"
  end

  create_table "sound_contexts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "context_type"
    t.integer "context_id"
    t.integer "sound_id"
    t.index ["context_type", "context_id"], name: "index_sound_contexts_on_context_type_and_context_id"
    t.index ["sound_id"], name: "index_sound_contexts_on_sound_id"
  end

  create_table "sounds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "volume"
    t.string "name"
    t.string "file"
    t.integer "loops"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spheres", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "panorama"
    t.string "caption"
    t.integer "memory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_zoom", default: 50
    t.string "guid"
    t.boolean "panorama_processing", default: false, null: false
    t.string "panorama_tmp"
    t.index ["guid"], name: "index_spheres_on_guid"
    t.index ["memory_id"], name: "index_spheres_on_memory_id"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "microposts", "users"
end
