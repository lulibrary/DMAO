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

ActiveRecord::Schema.define(version: 20160927151902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "dmao_admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_dmao_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_dmao_admins_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_dmao_admins_on_unlock_token", unique: true, using: :btree
  end

  create_table "ingest_jobs", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "ingest_time"
    t.string   "status"
    t.string   "ingest_type"
    t.string   "ingest_mode"
    t.string   "ingest_area"
    t.integer  "institution_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "ingest_log_file"
    t.index ["institution_id"], name: "index_ingest_jobs_on_institution_id", using: :btree
  end

  create_table "institution_admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.integer  "institution_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_institution_admins_on_email", unique: true, using: :btree
    t.index ["institution_id"], name: "index_institution_admins_on_institution_id", using: :btree
    t.index ["reset_password_token"], name: "index_institution_admins_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_institution_admins_on_unlock_token", unique: true, using: :btree
  end

  create_table "institution_configurations", force: :cascade do |t|
    t.json     "systems_configuration"
    t.integer  "institution_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["institution_id"], name: "index_institution_configurations_on_institution_id", using: :btree
  end

  create_table "institution_organisation_units", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "system_uuid"
    t.datetime "system_modified_at"
    t.string   "isni"
    t.string   "unit_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "institution_id"
    t.uuid     "parent_id"
    t.index ["institution_id"], name: "index_institution_organisation_units_on_institution_id", using: :btree
    t.index ["parent_id"], name: "index_institution_organisation_units_on_parent_id", using: :btree
  end

  create_table "institution_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.integer  "institution_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_institution_users_on_email", unique: true, using: :btree
    t.index ["institution_id"], name: "index_institution_users_on_institution_id", using: :btree
    t.index ["reset_password_token"], name: "index_institution_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_institution_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.string   "identifier"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone_number"
    t.string   "locale"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["identifier"], name: "index_institutions_on_identifier", unique: true, using: :btree
  end

  create_table "systems_configuration_keys", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "systemable_type"
    t.integer  "systemable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "secure"
    t.index ["systemable_type", "systemable_id"], name: "index_systems_configuration_keys_on_systemable", using: :btree
  end

  create_table "systems_configuration_values", force: :cascade do |t|
    t.string   "encrypted_value"
    t.integer  "institution_id"
    t.integer  "systems_configuration_key_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["institution_id"], name: "index_systems_configuration_values_on_institution_id", using: :btree
    t.index ["systems_configuration_key_id"], name: "index_configuration_values_on_configuration_key_id", using: :btree
  end

  create_table "systems_cris_systems", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "version"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "organisation_ingester"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "ingest_jobs", "institutions"
  add_foreign_key "systems_configuration_values", "institutions"
  add_foreign_key "systems_configuration_values", "systems_configuration_keys"
end
