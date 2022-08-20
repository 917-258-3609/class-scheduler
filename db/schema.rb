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

ActiveRecord::Schema[7.0].define(version: 2022_08_20_233803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.decimal "fee", precision: 10, scale: 2
    t.string "location"
    t.string "comment"
    t.boolean "is_active"
    t.bigint "teacher_id"
    t.bigint "subject_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_level_id"], name: "index_courses_on_subject_level_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "courses_students", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "student_id", null: false
    t.index ["course_id", "student_id"], name: "index_courses_students_on_course_id_and_student_id"
    t.index ["student_id", "course_id"], name: "index_courses_students_on_student_id_and_course_id"
  end

  create_table "occurrences", force: :cascade do |t|
    t.datetime "start_time"
    t.integer "count"
    t.integer "days", array: true
    t.interval "period"
    t.interval "duration"
    t.bigint "schedule_id"
    t.jsonb "ice_cube_b"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_time"
    t.index ["schedule_id"], name: "index_occurrences_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "scheduleable_type"
    t.bigint "scheduleable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scheduleable_type", "scheduleable_id"], name: "index_schedules_on_scheduleable"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_levels", force: :cascade do |t|
    t.string "subject"
    t.integer "level"
    t.string "level_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subject_id"
    t.index ["subject_id"], name: "index_subject_levels_on_subject_id"
  end

  create_table "subject_levels_teachers", id: false, force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "subject_level_id", null: false
    t.index ["teacher_id", "subject_level_id"], name: "subject_teacher"
    t.index ["teacher_id", "subject_level_id"], name: "teacher_subject"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.decimal "balance", precision: 10, scale: 2
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accountable_type", "accountable_id"], name: "index_users_on_accountable"
  end

end
