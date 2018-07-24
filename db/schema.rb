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

ActiveRecord::Schema.define(version: 0) do

  create_table "C$_1teachers", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "C10_PHYSICAL_CARD_NUMBER"
    t.string "C11_SFRZH", limit: 20
  end

  create_table "alumnus", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "id", null: false, auto_increment: true
    t.string "card_number", null: false
    t.string "name"
    t.string "gender"
    t.string "head_image"
    t.string "grade"
    t.string "college"
    t.string "profession"
    t.string "class"
    t.string "identity_type"
    t.string "identity_title"
    t.string "id_card"
    t.string "telephone"
    t.string "organization"
    t.string "campus"
    t.string "dorm_number"
    t.string "remark"
    t.string "physical_chip_number"
    t.string "physical_card_number"
    t.index ["card_number"], name: "card_number", unique: true
    t.index ["id"], name: "id", unique: true
    t.index ["id_card"], name: "id_card", unique: true
  end

  create_table "students", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "id", null: false, auto_increment: true
    t.string "card_number", null: false
    t.string "name"
    t.string "gender"
    t.string "head_image"
    t.string "grade"
    t.string "college"
    t.string "profession"
    t.string "class"
    t.string "identity_type"
    t.string "identity_title"
    t.string "id_card"
    t.string "telephone"
    t.string "organization"
    t.string "campus"
    t.string "dorm_number"
    t.string "remark"
    t.string "physical_chip_number"
    t.string "physical_card_number"
    t.index ["card_number"], name: "card_number", unique: true
    t.index ["id"], name: "id", unique: true
    t.index ["id_card"], name: "id_card", unique: true
  end

  create_table "teachers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "card_number", null: false
    t.string "name"
    t.string "gender"
    t.string "head_image"
    t.string "grade"
    t.string "college"
    t.string "profession"
    t.string "class"
    t.string "identity_type"
    t.string "identity_title"
    t.string "id_card"
    t.string "telephone"
    t.string "organization"
    t.string "campus"
    t.string "dorm_number"
    t.string "remark"
    t.string "physical_chip_number"
    t.string "physical_card_number"
    t.index ["card_number"], name: "card_number", unique: true
    t.index ["id"], name: "id", unique: true
    t.index ["id_card"], name: "id_card", unique: true
  end

end
