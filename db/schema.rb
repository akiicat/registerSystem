# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160726082728) do

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "account"
    t.string   "password"
    t.string   "salt"
    t.string   "confirm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "admins", ["confirm"], name: "index_admins_on_confirm"

  create_table "categories", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "entry_group_id"
    t.integer  "vacancy_id"
    t.integer  "coop_vacancy_id"
    t.boolean  "personal"
    t.boolean  "coop_personal"
    t.integer  "replaced_id"
    t.integer  "coop_replaced_id"
    t.integer  "year"
    t.string   "status"
    t.boolean  "coop"
    t.boolean  "repl"
    t.integer  "waiting_list"
    t.string   "name"
    t.string   "email"
    t.string   "contact"
    t.string   "studentID"
    t.string   "confirm"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "entry"
  end

  add_index "students", ["confirm"], name: "index_students_on_confirm"
  add_index "students", ["coop_vacancy_id"], name: "index_students_on_coop_vacancy_id"
  add_index "students", ["group_id"], name: "index_students_on_group_id"
  add_index "students", ["vacancy_id"], name: "index_students_on_vacancy_id"

  create_table "teacher_categoryships", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "teacher_categoryships", ["category_id"], name: "index_teacher_categoryships_on_category_id"
  add_index "teacher_categoryships", ["teacher_id"], name: "index_teacher_categoryships_on_teacher_id"

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.integer  "title_id"
    t.string   "education"
    t.text     "specialty"
    t.string   "contact"
    t.string   "email"
    t.string   "note"
    t.float    "default_ratio"
    t.string   "account"
    t.string   "password"
    t.string   "salt"
    t.string   "confirm"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "teachers", ["confirm"], name: "index_teachers_on_confirm"
  add_index "teachers", ["title_id"], name: "index_teachers_on_title_id"

  create_table "titles", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vacancies", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "year"
    t.boolean  "archive"
    t.float    "ratio"
    t.string   "number"
    t.string   "used"
    t.string   "confirm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "vacancies", ["confirm"], name: "index_vacancies_on_confirm"
  add_index "vacancies", ["teacher_id"], name: "index_vacancies_on_teacher_id"

end
