class PopulateOccupation
  include Interactor

  def call
    return if context.pathway[:occupation].present? && context.pathway[:occupation].length > 0

    post_secondary_programs = context.pathway[:post_secondary]

    context.pathway[:occupation] = related_occupations(post_secondary_programs)
  end

  private

  def related_occupations(post_secondary_programs)
    ouac_codes = post_secondary_programs.collect { |program| program.ouac_program_code }
    cat_codes = OuacProgramCategoryMap.where(ouac_program_code: ouac_codes).pluck(:ouac_cat_code).uniq
    top_cat_codes = OuacProgramCategory.find(cat_codes).pluck(:ouac_top_code).uniq
    maesd_program_codes = OuacMaesdMap.where(ouac_top_code: top_cat_codes).pluck(:program_code).uniq
    cip_top_codes = CipMaesdMap.where(program_code: maesd_program_codes).pluck(:cip_top_code).uniq
    cip_program_codes = CipProgram.where(cip_top_code: cip_top_codes).pluck(:cip_program_code)
    noc_codes = SpecificProgram.where(cip_program_code: cip_program_codes).pluck(:noc_code)

    if context.pathway[:occupation].present?
      context.pathway[:occupation].where(noc_code: noc_codes)
    else
      Occupation.where(noc_code: noc_codes)
    end
  end
end