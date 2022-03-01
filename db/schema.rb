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

ActiveRecord::Schema.define(version: 2022_03_01_164153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "communes", force: :cascade do |t|
    t.string "name"
    t.integer "zipinsee"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "latitude"
    t.decimal "longitude"
  end

  create_table "ecoles", force: :cascade do |t|
    t.string "type"
    t.string "statut"
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "commune_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commune_id"], name: "index_ecoles_on_commune_id"
  end

  create_table "gares", force: :cascade do |t|
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "commune_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commune_id"], name: "index_gares_on_commune_id"
  end

  create_table "pharmacies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "zip_code"
    t.decimal "lattitude"
    t.decimal "longitude"
    t.bigint "commune_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commune_id"], name: "index_pharmacies_on_commune_id"
  end

  add_foreign_key "ecoles", "communes"
  add_foreign_key "gares", "communes"
  add_foreign_key "pharmacies", "communes"
end
