class OuacUniversityProgram < ApplicationRecord
  self.table_name = 'university_programs_ouac_code'

  has_many :university_prereq_groups, foreign_key: [:ouac_univ_code, :ouac_program_code, :program_type, :specialization], primary_key: [:ouac_univ_code, :ouac_program_code, :program_type, :specialization]
  has_many :university_prereqs, through: :university_prereq_groups

  has_and_belongs_to_many :maesd_programs, join_table: :maesd_programs_ouac_university_programs
  has_many :occupations, through: :maesd_programs
end
