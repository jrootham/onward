class HighSchoolCourse < ApplicationRecord
  self.table_name = 'hs_courses'

  has_one :course_prerequisite, foreign_key: 'course_code'

  def prereq
    return if has_prereq === 0

    self.class.find_by(course_code: course_prerequisite.prereq_code)
  end
end
