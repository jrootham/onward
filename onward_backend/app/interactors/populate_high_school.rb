class PopulateHighSchool
  include Interactor

  HIGH_SCHOOL_LEVELS = %w(pre_hs grade_9 grade_10 grade_11 grade_12)

  def call
    context.current_level = context.query_params[:current_level] || 'pre_hs'
    return unless HIGH_SCHOOL_LEVELS.include? context.current_level

    populate_current_courses
    populate_course_options
  end

  private

  def populate_current_courses
    if context.query_params[:hs_courses]
      courses = HighSchoolCourse.includes(:course_prerequisite, :course_grade).find(context.query_params[:hs_courses])

      courses.each do |course|
        hash_key = "grade_#{course.grade}"
        context.pathway[hash_key].push course
      end
    else
      return if context.current_level == 'pre_hs'
      courses = courses_by_grade(context.current_level)
      context.pathway[context.current_level] = courses.to_a
    end
  end

  def populate_course_options
    return if context.current_level == 'grade_12'

    current_level_index = HIGH_SCHOOL_LEVELS.index(context.current_level)
    grade_11_index = HIGH_SCHOOL_LEVELS.index('grade_11')


    levels_to_populate = HIGH_SCHOOL_LEVELS[current_level_index..grade_11_index]
    levels_to_populate.each do |level|
      next_year_courses(level)
    end
  end

  def next_year_courses(current_level)
    current_courses = context.pathway[current_level]
    nx_level = next_level(current_level)
    # open_courses = courses_by_grade(nx_level)
    return if context.pathway[nx_level].length > 1

    context.pathway[nx_level] = context.pathway[nx_level].tap do |courses|
      current_courses.map { |course| courses << course.prereq_for }
      # courses << open_courses if open_courses.present?
      courses.flatten!
    end
  end

  def next_level(current_level)
    current_level_index = HIGH_SCHOOL_LEVELS.index(current_level)

    return if current_level_index === HIGH_SCHOOL_LEVELS.length - 1

    HIGH_SCHOOL_LEVELS[HIGH_SCHOOL_LEVELS.index(current_level) + 1]
  end

  def courses_by_grade(level, prereq=false)
    return if level == 'pre_hs'
    grade = level.split('grade_')[1]

    course_codes = CourseGrade.where(grade: grade).pluck(:course_code)
    courses = HighSchoolCourse.where(course_code: course_codes, has_prereq: prereq)
  end
end