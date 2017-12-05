class SelectPostSecondary
  include Interactor

  VALID_PARAMS = [:ouac_codes, :uni_codes]
  BATCH_SIZE = 10
  TARGET = 10
  DEFAULT_HS_COURSES = ['ENG4U']

  def call
    hs_course_codes = context.query_params[:hs_courses] || DEFAULT_HS_COURSES
    prereqs = UniversityPrereq.includes(:ouac_university_program).where(hs_course_code: hs_course_codes)
    context.pathway[:post_secondary] = find_eligible_programs(hs_course_codes, prereqs, [], 0)
    p "PARAMS: #{context.query_params}"
  end

  private

  def select_post_secondary(limit, offset)
    valid_params = valid_params = VALID_PARAMS.any? { |param| context.query_params[param].present? }
    return unless context.pathway[:occupation].present? || valid_params

    collection = OuacUniversityProgram.includes(:maesd_programs)

    if context.query_params[:ouac_codes].present?
      return collection.where(ouac_program_code: context.query_params[:ouac_codes]).limit(limit).offset(offset)
    end

    # if context.pathway[:uni_codes].present?
    #   return collection.where(ouac_univ_code: context.pathway[:uni_codes])
    # end

    if context.pathway[:occupation].present?
      return context.pathway[:occupation].limit(limit).offset(offset).map(&:ouac_university_program_random)
    end
  end

  def find_eligible_programs(hs_course_codes, prereqs, eligible_programs, offset)
    return eligible_programs if eligible_programs.count >= 10

    batch_of_programs = select_post_secondary(BATCH_SIZE, offset)

    batch_of_programs.each do |program|
      eligible_programs << program if prereqs_met?(program, prereqs)
    end

    p ">>>>>>>>>>>>>>>> eliigble_program count: #{eligible_programs.count}, offset: #{offset}"

    return eligible_programs if batch_of_programs.count < BATCH_SIZE

    find_eligible_programs(hs_course_codes, prereqs, eligible_programs, offset + BATCH_SIZE)
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