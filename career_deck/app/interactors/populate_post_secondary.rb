class PopulatePostSecondary
  include Interactor

  PS_PARAMS = [:occupation, :ouac_codes, :uni_codes]

  def call
    return if PS_PARAMS.any? { |param| context.query_params[param].present? }
    return unless context.pathway[:post_secondary].empty?

    grade_12_courses = context.pathway[:grade_12]

    context.pathway[:post_secondary] = eligible_university_programs(grade_12_courses)

  rescue => e
    context.fail! message: "Error populating post secondary programs: #{e}"
  end

  private

  def eligible_university_programs(grade_12_courses)
    hs_course_codes = grade_12_courses.map(&:course_code)

    generate_eligible_programs(0, hs_course_codes, [])
  end

  def generate_eligible_programs(current_index, hs_course_codes, eligible_programs)
    return eligible_programs if eligible_programs.count >= 10

    potential_program = OuacUniversityProgram.offset(current_index).first

    return unless potential_program.present?

    eligible_programs << potential_program if prereqs_met?(potential_program, hs_course_codes)
    generate_eligible_programs(current_index + 1, hs_course_codes, eligible_programs)
  end

  def prereqs_met?(program, hs_course_codes)
    program.university_prereq_groups.required.each do |prereq_group|
      selection_group = prereq_group.university_prereqs
      matches = selection_group.where(hs_course_code: hs_course_codes).count
      return false unless matches >= prereq_group.num_picks_required
    end
    return true
  end
end
