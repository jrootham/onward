class Pathway
  attr_accessor :result

  LEVELS = [
    {
      name: 'grade_9',
      options_next_level: 'next_year_courses',
      options_previous_level: nil
    },
    {
      name: 'grade_10',
      options_next_level: 'next_year_courses',
      options_previous_level: 'previous_year_courses'
    },
    {
      name: 'grade_11',
      options_next_level: 'next_year_courses',
      options_previous_level: 'previous_year_courses'
    },
    {
      name: 'grade_12',
      options_next_level: 'university_programs',
      options_previous_level: 'previous_year_courses'
    },
    {
      name: 'university',
      options_next_level: 'occupation_options',
      options_previous_level: 'high_school_prerequisites'
    },
    {
      name: 'occupation',
      options_next_level: nil,
      options_previous_level: 'credentials'
    }
  ]

  def initialize(hs_course_codes: [], current_level: 'grade_9')
    @result = Hash[LEVELS.map{ |level| [level[:name], []] }]
    binding.pry
    courses = hs_course_codes.each { |cc| HighSchoolCourse.includes(:course_prerequisite, :course_grade).find(cc) }
    populate_high_school_courses(courses)
    generate_pathway(current_level)
  end

  def populate_high_school_courses(courses)
    courses.each do |course|
      hash_key = "grade_#{course.grade}"
      @result[hash_key].push course
    end
  end

  # def detect_current_grade(courses)
  #   course_grades = courses.map { |c| c.grade }
  #   freq = course_grades.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  #   freq.max_by { |_, v| v }.first
  # end

  def generate_pathway(current_level_name)
    current_level = LEVELS.select { |level| level[:name] = current_level_name }
    next_level = LEVELS[LEVELS.index_of(current_level_item) + 1]
    method_name = next_level[options_next_level]
    send(method_name, current_level, next_level)
    generate_pathway(next_level)
  end

  def next_year_courses(current_level, next_level)
    current_courses = @result[current_level[:name]]
    @result[next_level[:name]] = current_courses.map { |course| course.prereq }
  end

  def previous_year_courses(current_level, previous_level)
    current_courses = @result[current_level[:name]]
    @result[previous_level[:name]] = courses.map { |course| course.prereq_for }.flatten
  end
end
