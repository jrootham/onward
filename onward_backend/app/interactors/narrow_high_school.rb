class NarrowHighSchool
  include Interactor

  HIGH_SCHOOL_LEVELS = %w(pre_hs grade_9 grade_10 grade_11 grade_12)

  def call
    context.current_level = context.query_params[:current_level] || 'pre_hs'
    return unless HIGH_SCHOOL_LEVELS.include? context.current_level

    narrow_by_post_secondary_program
    narrow_by_prerequisites
  end

  private


  def narrow_by_post_secondary_program
    return unless context.pathway[:post_secondary]

    ouac_program_codes = context.pathway[:post_secondary].map(&:ouac_program_code)
    prereq_ids = UniversityPrereq.where(ouac_program_code: ouac_program_codes).pluck(:hs_course_code).uniq
    context.pathway[:grade_12].concat HighSchoolCourse.where(course_code: prereq_ids)
  end

  def narrow_by_prerequisites
    return if context.current_level == 'grade_12'
    previous_year_courses('grade_12')
  end


  def previous_year_courses(current_level)
    current_courses = context.pathway[current_level]
    prev_level = previous_level(current_level)

    context.pathway[prev_level] = context.pathway[prev_level].tap do |courses|
      courses << current_courses.map { |course| course.prereq }
      courses.flatten!
    end
  end

  def previous_level(current_level)
    current_level_index = HIGH_SCHOOL_LEVELS.index(current_level)

    return if current_level_index === 0

    HIGH_SCHOOL_LEVELS[current_level_index - 1]
  end
end