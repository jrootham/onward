class HighSchoolCourse < ApplicationRecord
  self.table_name = 'hs_courses'

  scope :no_prereq, -> { where(has_prereq: false) }

  has_one :course_prerequisite, foreign_key: 'course_code'
  has_one :course_grade, foreign_key: 'course_code'

  PRIORITY_SUBJECTS = ['ENG', 'M', 'S'] # English, Math, Science

  def prereq
    return if has_prereq === 0

    return unless course_prerequisite

    self.class.find_by(course_code: course_prerequisite.prereq_code)
  end

  def grade
    course_grade.grade
  end

  def prereq_for
    course_ids = CoursePrerequisite.where(prereq_code: course_code).pluck(:course_code)
    self.class.find(course_ids)
  end
end
