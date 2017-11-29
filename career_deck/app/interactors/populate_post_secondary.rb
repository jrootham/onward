class PopulatePostSecondary
  include Interactor

  def call
    return if context.pathway[:post_secondary].present? && context.pathway[:post_secondary].length > 0

    grade_12_courses = context.pathway[:grade_12]

    program_options = eligible_university_programs(grade_12_courses)
    context.pathway[:post_secondary] = program_options # TODO add more data for university program
  end

  private

  def eligible_university_programs(grade_12_courses)
    hs_course_codes = grade_12_courses.map(&:course_code)
    prereqs = UniversityPrereq.includes(:ouac_university_program).where(hs_course_code: hs_course_codes)
    potential_programs = prereqs.map(&:ouac_university_program).uniq

    potential_programs.keep_if { |program| prereqs_met?(program, prereqs) }
  end
end

def prereqs_met?(program, prereqs)
  program.university_prereq_groups.required.each do |prereq_group|
    selection_group = prereq_group.university_prereqs
    matches = selection_group.where(id: prereqs).count
    return false unless matches >= prereq_group.num_picks_required
  end
  return true
end