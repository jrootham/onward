class HighSchoolCourseSelection
  def self.call(courses, direction: 'next')
    return next_courses(courses) if direction === 'next'
    previous_courses(courses)
  end

  def self.previous_courses(courses)
    courses.map { |course| course.prereq }
  end

  def self.next_courses(courses)
    courses.map { |course| course.prereq_for }.flatten
  end
end