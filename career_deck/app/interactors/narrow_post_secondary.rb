class NarrowPostSecondary
  include Interactor

   VALID_PARAMS = [:occupation, :ouac_codes, :uni_codes, :eligiblity]

  def call
    select_post_secondary

  rescue => e
    context.fail! message: "Error selecting post secondary options: #{e}"
  end

  private

  def select_post_secondary
    VALID_PARAMS.each do |param|
      next unless context.query_params[param].present?
      next if context.pathway[:post_secondary].count =< 1

      programs = context.pathway[:post_secondary] || OuacUniversityProgram.includes(:university_prereq_groups)
      send("select_by_#{param}", programs)
    end
  end

  def select_by_occupation(programs)
    occ_count = context.pathway[:occupation].count
    target = 50
    programs_per_occupation = occ_count >= target ? 1 : target / occ_count
    ouac_ids = context.pathway[:occupation].map(&:ouac_university_programs).first(programs_per_occupation).flatten.uniq.pluck(:id)

    context.pathway[:post_secondary] = programs.where(id: ouac_ids)
  end

  def select_by_ouac_codes(programs)
    context.pathway[:post_secondary] = programs.where(ouac_program_code: context.query_params[:ouac_codes])
  end

  def select_by_uni_codes(programs)
    context.pathway[:post_secondary] = programs.where(ouac_univ_code: context.pathway[:uni_codes])
  end

  def select_by_eligibility(programs)
    prereqs = UniversityPrereq.includes(:ouac_university_program).where(hs_course_code: context.query_params[:hs_courses])

    context.pathway[:post_secondary] = programs.keep_if do |program|
      prereqs_met?(program, prereqs)
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
end