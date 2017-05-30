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

ActiveRecord::Schema.define(version: 20170525000735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "records", force: :cascade do |t|
    t.string   "documentstatus"
    t.string   "filetype"
    t.string   "boxdesc1"
    t.string   "pagecount"
    t.string   "documentpath"
    t.string   "documentid"
    t.string   "boxdesc2"
    t.string   "employernumber"
    t.string   "batchid"
    t.string   "filedesc1"
    t.string   "filestatus"
    t.string   "filedesc2"
    t.string   "employername"
    t.string   "boxretentiondate"
    t.string   "dsfile"
    t.string   "account"
    t.string   "documentdesc1"
    t.string   "workorder"
    t.string   "migrated"
    t.string   "documentdesc2"
    t.string   "boxstatus"
    t.string   "pickupdate"
    t.string   "dsbox"
    t.string   "document"
    t.string   "scandate"
    t.string   "documenttype"
    t.string   "fileretentiondate"
    t.string   "documentretentiondate"
    t.string   "boxlocation"
    t.string   "filehash"
    t.string   "cisfile"
    t.string   "name"
    t.string   "ssn"
    t.string   "id2"
    t.string   "ocrpath"
    t.string   "docid"
    t.string   "database"
    t.string   "cisbox"
    t.string   "documentretetiondate"
    t.string   "fileid"
    t.string   "toboxdesc"
    t.string   "fromboxdesc"
    t.string   "employercity"
    t.string   "employerdate"
    t.string   "version4notsupported"
    t.string   "batchdate"
    t.string   "batchnumber"
    t.string   "batchcreatedatetime"
    t.string   "order"
    t.string   "pudate"
    t.string   "mdbhash"
    t.string   "r"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["name"], name: "index_records_on_name", using: :btree
    t.index ["r"], name: "index_records_on_r", using: :btree
    t.index ["ssn"], name: "index_records_on_ssn", using: :btree
  end

  create_table "things", force: :cascade do |t|
    t.string   "path"
    t.string   "h"
    t.string   "r"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["r"], name: "index_things_on_r", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
