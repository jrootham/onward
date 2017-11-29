class CoursePrerequisite < ApplicationRecord
  self.table_name = 'hs_course_prereq'

  belongs_to :high_school_course, foreign_key: 'course_code'
end
