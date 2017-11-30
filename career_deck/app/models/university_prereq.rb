class UniversityPrereq < ApplicationRecord
  self.table_name = 'univ_prereq_course'

  has_one :university_prereq_group, foreign_key: [:ouac_univ_code, :ouac_program_code, :program_type, :specialization, :prereq_group_num], primary_key: [:ouac_univ_code, :ouac_program_code, :program_type, :specialization, :prereq_group_num]

  has_one :ouac_university_program, through: :university_prereq_group
end
