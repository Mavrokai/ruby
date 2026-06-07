# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_07_120300) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chat_messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "npc_id"
    t.integer "quest_progress_id", null: false
    t.string "sender", default: "gm", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_chat_messages_on_created_at"
    t.index ["npc_id"], name: "index_chat_messages_on_npc_id"
    t.index ["quest_progress_id"], name: "index_chat_messages_on_quest_progress_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "item_id", null: false
    t.integer "player_id", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_inventory_items_on_item_id"
    t.index ["player_id", "item_id"], name: "index_inventory_items_on_player_id_and_item_id"
    t.index ["player_id"], name: "index_inventory_items_on_player_id"
  end

  create_table "items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "force_bonus", default: 0, null: false
    t.integer "health_bonus", default: 0, null: false
    t.string "name", null: false
    t.string "slot", null: false
    t.datetime "updated_at", null: false
    t.integer "xp_bonus", default: 0, null: false
    t.index ["slot"], name: "index_items_on_slot"
  end

  create_table "market_listings", force: :cascade do |t|
    t.integer "buyer_id"
    t.datetime "created_at", null: false
    t.integer "inventory_item_id"
    t.integer "item_id", null: false
    t.integer "price", default: 0, null: false
    t.integer "seller_id"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_market_listings_on_buyer_id"
    t.index ["inventory_item_id"], name: "index_market_listings_on_inventory_item_id"
    t.index ["item_id"], name: "index_market_listings_on_item_id"
    t.index ["seller_id"], name: "index_market_listings_on_seller_id"
    t.index ["status"], name: "index_market_listings_on_status"
  end

  create_table "npcs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "force", default: 5, null: false
    t.integer "max_health", default: 10, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "accent_color", default: "#d4a44a", null: false
    t.integer "available_stat_points", default: 10, null: false
    t.datetime "created_at", null: false
    t.integer "current_health", default: 10, null: false
    t.integer "equipped_belt_id"
    t.integer "equipped_boots_id"
    t.integer "equipped_cape_id"
    t.integer "equipped_chest_id"
    t.integer "equipped_gloves_id"
    t.integer "equipped_hat_id"
    t.integer "equipped_legs_id"
    t.integer "equipped_shield_id"
    t.integer "equipped_staff_id"
    t.integer "equipped_weapon_2h_id"
    t.integer "equipped_weapon_id"
    t.integer "experience", default: 0, null: false
    t.integer "force", default: 10, null: false
    t.integer "gold", default: 50, null: false
    t.integer "level", default: 1, null: false
    t.integer "max_health", default: 10, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["equipped_belt_id"], name: "index_players_on_equipped_belt_id"
    t.index ["equipped_boots_id"], name: "index_players_on_equipped_boots_id"
    t.index ["equipped_cape_id"], name: "index_players_on_equipped_cape_id"
    t.index ["equipped_chest_id"], name: "index_players_on_equipped_chest_id"
    t.index ["equipped_gloves_id"], name: "index_players_on_equipped_gloves_id"
    t.index ["equipped_hat_id"], name: "index_players_on_equipped_hat_id"
    t.index ["equipped_legs_id"], name: "index_players_on_equipped_legs_id"
    t.index ["equipped_shield_id"], name: "index_players_on_equipped_shield_id"
    t.index ["equipped_staff_id"], name: "index_players_on_equipped_staff_id"
    t.index ["equipped_weapon_2h_id"], name: "index_players_on_equipped_weapon_2h_id"
    t.index ["equipped_weapon_id"], name: "index_players_on_equipped_weapon_id"
    t.index ["name"], name: "index_players_on_name", unique: true
  end

  create_table "quest_progresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_npc_health"
    t.integer "current_step_position", default: 1, null: false
    t.integer "player_id", null: false
    t.integer "quest_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "quest_id"], name: "index_quest_progresses_on_player_id_and_quest_id"
    t.index ["player_id"], name: "index_quest_progresses_on_player_id"
    t.index ["quest_id"], name: "index_quest_progresses_on_quest_id"
    t.index ["status"], name: "index_quest_progresses_on_status"
  end

  create_table "quest_rewards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "item_id", null: false
    t.integer "quest_id", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_quest_rewards_on_item_id"
    t.index ["quest_id"], name: "index_quest_rewards_on_quest_id"
  end

  create_table "quest_step_answers", force: :cascade do |t|
    t.string "content", null: false
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "quest_step_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_step_id"], name: "index_quest_step_answers_on_quest_step_id"
  end

  create_table "quest_steps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "gold_reward", default: 5, null: false
    t.integer "npc_id", null: false
    t.integer "position", null: false
    t.integer "quest_id", null: false
    t.string "riddle_question", null: false
    t.integer "step_xp_reward", default: 10, null: false
    t.datetime "updated_at", null: false
    t.index ["npc_id"], name: "index_quest_steps_on_npc_id"
    t.index ["quest_id", "position"], name: "index_quest_steps_on_quest_id_and_position", unique: true
    t.index ["quest_id"], name: "index_quest_steps_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "final_xp_reward", default: 50, null: false
    t.integer "gold_reward", default: 20, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_messages", "npcs"
  add_foreign_key "chat_messages", "quest_progresses"
  add_foreign_key "inventory_items", "items"
  add_foreign_key "inventory_items", "players"
  add_foreign_key "market_listings", "inventory_items"
  add_foreign_key "market_listings", "items"
  add_foreign_key "market_listings", "players", column: "buyer_id"
  add_foreign_key "market_listings", "players", column: "seller_id"
  add_foreign_key "players", "items", column: "equipped_belt_id"
  add_foreign_key "players", "items", column: "equipped_boots_id"
  add_foreign_key "players", "items", column: "equipped_cape_id"
  add_foreign_key "players", "items", column: "equipped_chest_id"
  add_foreign_key "players", "items", column: "equipped_gloves_id"
  add_foreign_key "players", "items", column: "equipped_hat_id"
  add_foreign_key "players", "items", column: "equipped_legs_id"
  add_foreign_key "players", "items", column: "equipped_shield_id"
  add_foreign_key "players", "items", column: "equipped_staff_id"
  add_foreign_key "players", "items", column: "equipped_weapon_2h_id"
  add_foreign_key "players", "items", column: "equipped_weapon_id"
  add_foreign_key "quest_progresses", "players"
  add_foreign_key "quest_progresses", "quests"
  add_foreign_key "quest_rewards", "items"
  add_foreign_key "quest_rewards", "quests"
  add_foreign_key "quest_step_answers", "quest_steps"
  add_foreign_key "quest_steps", "npcs"
  add_foreign_key "quest_steps", "quests"
end
