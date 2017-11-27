class OuacUniversityProgram < ApplicationRecord
  self.table_name = 'university_programs_ouac_code'
  self.primary_keys = :ouac_univ_code, :ouac_program_code, :program_type, :specialization

  has_many :university_prereq_groups, foreign_key: [:ouac_univ_code, :ouac_program_code, :program_type, :specialization], primary_key: [:ouac_univ_code, :ouac_program_code, :program_type, :specialization]

  def prereqs_met?(hs_course_codes)
    university_prereq_groups.required.each do |prereq_group|
      selection_group = prereq_group.hs_courses_in_group
      matching_courses = selection_group.keep_if { |c| hs_course_codes.include? c }
      return false unless matching_courses.count >= prereq_group.num_picks_required
    end
    return true
  end
end
