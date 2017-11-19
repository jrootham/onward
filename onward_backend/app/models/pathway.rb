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

    populate_high_school_courses(hs_course_codes)
    generate_pathway(level_from_name(current_level))
  end

  def level_from_name(level_name)
    LEVELS.find { |level| level[:name] == level_name } || LEVELS[0]
  end

  def populate_high_school_courses(hs_course_codes)
    courses = HighSchoolCourse.includes(:course_prerequisite, :course_grade).find(hs_course_codes)
    p "COURSES => #{courses}"

    courses.each do |course|
      hash_key = "grade_#{course.grade}"
      @result[hash_key].push course
    end
  end

  def generate_pathway(current_level)
    p "CURRENT_LEVEL => #{current_level}"
    p "@result => #{@result}"

    return @result unless current_level

    next_level = LEVELS[LEVELS.index(current_level) + 1]
    method_name = current_level[:options_next_level]

    send(method_name, current_level, next_level)
    generate_pathway(next_level)

  rescue NoMethodError => e
    puts "------------------------------"
    puts e
    return @result
    puts "------------------------------"
  end

  def previous_year_courses(current_level, previous_level)
    current_courses = @result[current_level[:name]]
    @result[previous_level[:name]] = @result[previous_level[:name]].tap do |courses|
      courses << current_courses.map { |course| course.prereq }
      courses.flatten!
    end
  end

  def next_year_courses(current_level, next_level)
    current_courses = @result[current_level[:name]]
    @result[next_level[:name]] = @result[next_level[:name]].tap do |courses|
      current_courses.map { |course| courses << course.prereq_for }
      courses.flatten!
    end
  end
end
