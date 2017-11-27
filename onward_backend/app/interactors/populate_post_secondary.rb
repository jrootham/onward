class PopulatePostSecondary
  include Interactor

  def call
    return if context.pathway[:post_secondary].present? && context.pathway[:post_secondary].length > 0

    grade_12_courses = context.pathway['grade_12']

    program_options = eligible_university_programs(grade_12_courses)
    context.pathway[:post_secondary] = populate_data program_options
  end

  private

  def eligible_university_programs(grade_12_courses)
    hs_course_codes = grade_12_courses.map(&:course_code)
    prereqs = UniversityPrereq.where(hs_course_code: hs_course_codes)
    potential_programs = prereqs.map(&:ouac_university_program).uniq
    potential_programs.keep_if { |program| program.prereqs_met? hs_course_codes }
  end

  def populate_data(ouac_university_programs)
    ouac_university_programs.collect do |program|
      program #todo add more data
    end
  end
end