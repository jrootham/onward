class UniversityPrereqGroup < ApplicationRecord
  self.table_name = 'univ_prereq_group'
  self.primary_keys = :ouac_univ_code, :ouac_program_code, :program_type, :specialization, :prereq_group_num

  scope :required, -> { where(recommended_group: false) }

  def hs_courses_in_group
    UniversityPrereq
      .where(ouac_univ_code: ouac_univ_code,
             ouac_program_code: ouac_program_code,
             program_type: program_type,
             specialization: specialization,
             prereq_group_num: prereq_group_num)
      .pluck(:hs_course_code)
  end
end

