class PopulatePostSecondary
  include Interactor

  PS_PARAMS = [:occupation, :ouac_codes, :uni_codes, :eligiblity]

  def call
    return if PS_PARAMS.any? { |param| context.query_params[param].present? }

    grade_12_courses = context.pathway[:grade_12]

    context.pathway[:post_secondary] = eligible_university_programs(grade_12_courses)

  rescue => e
    context.fail! message: "Error populating post secondary programs: #{e}"
  end

  private

  def eligible_university_programs(grade_12_courses)
    hs_course_codes = grade_12_courses.map(&:course_code)
    prereqs = UniversityPrereq.includes(:ouac_university_program).where(hs_course_code: hs_course_codes).to_a

    generate_eligible_programs(0, prereqs, [])
  end

  def generate_eligible_programs(current_index, prereqs, eligible_programs)
    return eligible_programs if eligible_programs.count >= 10
    return eligible_programs if current_index === prereqs.count - 1

    program = prereqs[current_index].ouac_university_program
    eligible_programs << program if prereqs_met?(program, prereqs)
    generate_eligible_programs(current_index + 1, prereqs, eligible_programs)
  end

  def prereqs_met?(program, prereqs)
    program.university_prereq_groups.required.each do |prereq_group|
      selection_group = prereq_group.university_prereqs
      matches = selection_group.where(id: prereqs).count
      return false unless matches >= prereq_group.num_picks_required
    end
    return true
  end
end
