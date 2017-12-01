class PopulateHighSchool
  include Interactor

  HIGH_SCHOOL_LEVELS = %w(grade_9 grade_10 grade_11 grade_12)

  def call
    context.current_level = context.query_params[:current_level]
    return unless HIGH_SCHOOL_LEVELS.include? context.current_level

    populate_current_courses
    populate_course_options(context.current_level)
  end

  private

  def populate_current_courses
    if context.query_params[:hs_courses]
      courses = HighSchoolCourse.includes(:course_prerequisite).find(context.query_params[:hs_courses])

      courses.each do |course|
        hash_key = "grade_#{course.grade}"
        context.pathway[hash_key].push course
      end
    else
      courses = courses_by_grade(context.current_level)
      context.pathway[context.current_level] = courses.to_a
    end
  end

  def populate_course_options(current_level)
    return if current_level == 'grade_12'

    current_courses = context.pathway[current_level]
    nx_level = next_level(current_level)
    open_courses = courses_by_grade(nx_level)
    return if context.pathway[nx_level].present? && context.pathway[nx_level].length > 1

    context.pathway[nx_level] = context.pathway[nx_level].tap do |courses|
      current_courses.map { |course| courses << course.prereq_for }
      courses << open_courses if open_courses.present?
      courses.flatten!
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