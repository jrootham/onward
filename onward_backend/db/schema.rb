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

ActiveRecord::Schema.define(version: 20171112230304) do

  create_table "apprentice_noc_wages_openings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "noc_code",        limit: 4
    t.integer "year"
    t.decimal "avg_hourly_wage",           precision: 6,  scale: 3
    t.decimal "vacancies",                 precision: 10, scale: 3
    t.index ["noc_code"], name: "noc_code", using: :btree
  end

  create_table "automation_risk", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "noc_code",        limit: 4
    t.decimal "automation_risk",           precision: 4, scale: 3
    t.index ["noc_code"], name: "noc_code", using: :btree
  end

  create_table "campuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "institution_code",      limit: 5
    t.string  "institution_type_code", limit: 8
    t.string  "campus_name"
    t.string  "campus_postal_code",    limit: 7
    t.integer "main_campus",           limit: 1
    t.index ["institution_code"], name: "institution_code", using: :btree
  end

  create_table "cip_codes", primary_key: "cip_program_code", id: :string, limit: 5, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "cip_top_code",   limit: 2
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
    t.index ["cip_top_code"], name: "cip_top_code", using: :btree
  end

  create_table "cip_top_level", primary_key: "cip_top_code", id: :string, limit: 2, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en"
    t.string "description_fr"
  end

  create_table "college_grad_rates", primary_key: ["institution_code", "college_program_code"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "institution_code",     limit: 5,                         null: false
    t.string  "college_program_code", limit: 5,                         null: false
    t.decimal "grad_rate",                      precision: 4, scale: 3
    t.index ["college_program_code"], name: "college_program_code", using: :btree
  end

  create_table "college_programs", primary_key: "college_program_code", id: :string, limit: 5, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 1000
    t.string "description_fr", limit: 1000
  end

  create_table "credentials", primary_key: "credential_code", id: :string, limit: 3, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  create_table "hs_course_grade_link", primary_key: ["course_code", "grade"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "course_code", limit: 13, null: false
    t.integer "grade",                  null: false
  end

  create_table "hs_course_prereq", primary_key: ["course_code", "prereq_code"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "course_code", limit: 13, null: false
    t.string "prereq_code", limit: 13, null: false
    t.index ["prereq_code"], name: "prereq_code", using: :btree
  end

  create_table "hs_courses", primary_key: "course_code", id: :string, limit: 13, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "course_name_en"
    t.string  "course_name_fr"
    t.integer "has_prereq",     limit: 1
  end

  create_table "institutions", primary_key: "institution_code", id: :string, limit: 5, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "institution_type", limit: 1
    t.string "institution_name"
    t.string "url"
  end

  create_table "noc_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "noc_code",              limit: 4
    t.string "description_en",        limit: 750
    t.string "description_fr",        limit: 750
    t.string "element_type",          limit: 4
    t.string "element_type_label_en", limit: 750
    t.string "element_type_label_fr", limit: 750
    t.index ["noc_code"], name: "noc_code", using: :btree
  end

  create_table "noc_skills", primary_key: "skill_code", id: :string, limit: 3, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  create_table "noc_skills_education", primary_key: "education_training_code", id: :string, limit: 3, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  create_table "noc_skills_levels", primary_key: ["skill_code", "level_code"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "skill_code",     limit: 3,   null: false
    t.string "level_code",     limit: 2,   null: false
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  create_table "noc_skills_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "task_code",          limit: 5
    t.string "noc_code",           limit: 4
    t.string "skill_code",         limit: 3
    t.string "level_code",         limit: 3
    t.string "education_training", limit: 3
    t.index ["education_training"], name: "education_training", using: :btree
    t.index ["noc_code"], name: "noc_code", using: :btree
    t.index ["skill_code"], name: "skill_code", using: :btree
    t.index ["task_code"], name: "task_code", using: :btree
  end

  create_table "noc_specific_program", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "noc_code",         limit: 4
    t.string  "credential_code",  limit: 3
    t.string  "cip_program_code", limit: 5
    t.integer "job_count"
    t.index ["cip_program_code"], name: "cip_program_code", using: :btree
    t.index ["credential_code"], name: "credential_code", using: :btree
    t.index ["noc_code"], name: "noc_code", using: :btree
  end

  create_table "noc_tasks", primary_key: "task_code", id: :string, limit: 5, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 3000
    t.string "description_fr", limit: 3000
  end

  create_table "noc_uniques", primary_key: "noc_code", id: :string, limit: 4, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "base_description_en", limit: 750
    t.string "base_description_fr", limit: 750
  end

  create_table "noc_wages", primary_key: "noc_code", id: :string, limit: 4, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "hourly_wage", precision: 6, scale: 2
    t.integer "yearly_wage"
  end

  create_table "occupations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "job_title"
    t.string   "noc_code"
    t.integer  "salary"
    t.float    "hourly_wage", limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["noc_code"], name: "index_occupations_on_noc_code", using: :btree
  end

  create_table "ouac_program_cat_map", primary_key: ["ouac_program_code", "ouac_cat_code"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "ouac_program_code", limit: 3, null: false
    t.integer "ouac_cat_code",               null: false
    t.index ["ouac_cat_code"], name: "ouac_cat_code", using: :btree
  end

  create_table "ouac_programs", primary_key: "ouac_program_code", id: :string, limit: 3, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  create_table "ouac_sub_categories", primary_key: "ouac_cat_code", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ouac_top_code"
    t.string  "description_en", limit: 750
    t.string  "description_fr", limit: 750
    t.index ["ouac_top_code"], name: "ouac_top_code", using: :btree
  end

  create_table "ouac_top_category", primary_key: "ouac_top_code", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  create_table "program_cip_link", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "program_code", limit: 3
    t.string "cip_code",     limit: 5
  end

  create_table "univ_noc_employment", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "year"
    t.string  "program_code",  limit: 3
    t.string  "noc_code",      limit: 4
    t.integer "employed"
    t.integer "self_employed"
    t.index ["noc_code"], name: "noc_code", using: :btree
    t.index ["program_code"], name: "program_code", using: :btree
  end

  create_table "univ_programs", primary_key: "program_code", id: :string, limit: 3, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description_en", limit: 750
    t.string "description_fr", limit: 750
  end

  add_foreign_key "apprentice_noc_wages_openings", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "apprentice_noc_wages_openings_ibfk_1", on_delete: :cascade
  add_foreign_key "automation_risk", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "automation_risk_ibfk_1", on_delete: :cascade
  add_foreign_key "campuses", "institutions", column: "institution_code", primary_key: "institution_code", name: "campuses_ibfk_1", on_delete: :cascade
  add_foreign_key "cip_codes", "cip_top_level", column: "cip_top_code", primary_key: "cip_top_code", name: "cip_codes_ibfk_1", on_delete: :cascade
  add_foreign_key "college_grad_rates", "college_programs", column: "college_program_code", primary_key: "college_program_code", name: "college_grad_rates_ibfk_2"
  add_foreign_key "college_grad_rates", "institutions", column: "institution_code", primary_key: "institution_code", name: "college_grad_rates_ibfk_1", on_delete: :cascade
  add_foreign_key "hs_course_grade_link", "hs_courses", column: "course_code", primary_key: "course_code", name: "hs_course_grade_link_ibfk_1", on_delete: :cascade
  add_foreign_key "hs_course_prereq", "hs_courses", column: "course_code", primary_key: "course_code", name: "hs_course_prereq_ibfk_1"
  add_foreign_key "hs_course_prereq", "hs_courses", column: "prereq_code", primary_key: "course_code", name: "hs_course_prereq_ibfk_2"
  add_foreign_key "noc_codes", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "noc_codes_ibfk_1", on_delete: :cascade
  add_foreign_key "noc_skills_levels", "noc_skills", column: "skill_code", primary_key: "skill_code", name: "noc_skills_levels_ibfk_1", on_delete: :cascade
  add_foreign_key "noc_skills_tasks", "noc_skills", column: "skill_code", primary_key: "skill_code", name: "noc_skills_tasks_ibfk_3", on_delete: :cascade
  add_foreign_key "noc_skills_tasks", "noc_skills_education", column: "education_training", primary_key: "education_training_code", name: "noc_skills_tasks_ibfk_4", on_delete: :cascade
  add_foreign_key "noc_skills_tasks", "noc_tasks", column: "task_code", primary_key: "task_code", name: "noc_skills_tasks_ibfk_1", on_delete: :cascade
  add_foreign_key "noc_skills_tasks", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "noc_skills_tasks_ibfk_2", on_delete: :cascade
  add_foreign_key "noc_specific_program", "cip_codes", column: "cip_program_code", primary_key: "cip_program_code", name: "noc_specific_program_ibfk_3", on_delete: :cascade
  add_foreign_key "noc_specific_program", "credentials", column: "credential_code", primary_key: "credential_code", name: "noc_specific_program_ibfk_2", on_delete: :cascade
  add_foreign_key "noc_specific_program", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "noc_specific_program_ibfk_1", on_delete: :cascade
  add_foreign_key "noc_wages", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "noc_wages_ibfk_1", on_delete: :cascade
  add_foreign_key "ouac_program_cat_map", "ouac_programs", column: "ouac_program_code", primary_key: "ouac_program_code", name: "ouac_program_cat_map_ibfk_2"
  add_foreign_key "ouac_program_cat_map", "ouac_sub_categories", column: "ouac_cat_code", primary_key: "ouac_cat_code", name: "ouac_program_cat_map_ibfk_1", on_delete: :cascade
  add_foreign_key "ouac_sub_categories", "ouac_top_category", column: "ouac_top_code", primary_key: "ouac_top_code", name: "ouac_sub_categories_ibfk_1", on_delete: :cascade
  add_foreign_key "univ_noc_employment", "noc_uniques", column: "noc_code", primary_key: "noc_code", name: "univ_noc_employment_ibfk_2"
  add_foreign_key "univ_noc_employment", "univ_programs", column: "program_code", primary_key: "program_code", name: "univ_noc_employment_ibfk_1"
end
