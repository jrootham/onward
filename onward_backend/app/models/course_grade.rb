class CourseGrade < ApplicationRecord
  self.table_name = 'hs_course_grade_link'

  belongs_to :high_school_course, foreign_key: 'course_code'
end
