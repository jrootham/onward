class PopulateHighSchoolCourses
  include Interactor

  HIGH_SCHOOL_LEVELS = %w(grade_9 grade_10 grade_11 grade_12)
  DEFAULT_COURSES = {
    grade_9: ['ENG4U'],
    grade_10: ['ENG4U'],
    grade_11: ['ENG4U'],
    grade_12: ['ENG4U'],
  }

  def call
    context.current_level = context.query_params[:current_level]
    context.fail!(message: 'Current level in high school must be provided') unless HIGH_SCHOOL_LEVELS.include? context.current_level

    populate_current_courses
    populate_course_options(context.current_level)

  rescue => e
    context.fail! message: "Error populating high school courses: #{e}"
  end

  private

  def populate_current_courses
    if context.query_params[:hs_courses]
      courses = HighSchoolCourse.find(context.query_params[:hs_courses])

      context.pathway[context.current_level].concat(courses).uniq!
    else
      context.pathway[context.current_level] = DEFAULT_COURSES[context.current_level]
    end
  end

  def populate_course_options(current_level)
    return if current_level == 'grade_12'

    current_courses = context.pathway[current_level]
    nx_level = next_level(current_level)

    context.pathway[nx_level] = context.pathway[nx_level].tap do |courses|
      current_courses.map { |course| courses << course.prereq_for }
      courses.flatten!
      courses.uniq!
    end

    populate_course_options(nx_level)
  end

  def next_level(current_level)
    current_level_index = HIGH_SCHOOL_LEVELS.index(current_level)

    return if current_level_index === HIGH_SCHOOL_LEVELS.length - 1

    HIGH_SCHOOL_LEVELS[HIGH_SCHOOL_LEVELS.index(current_level) + 1]
  end

  def courses_by_grade(level, prereq=false)
    grade = level.split('grade_')[1]
    HighSchoolCourse.no_prereq.joins(:course_grade).where('hs_course_grade_link.grade = ?', grade).limit(10)
  end
end