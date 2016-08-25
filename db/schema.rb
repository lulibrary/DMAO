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

ActiveRecord::Schema.define(version: 20160825135814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
