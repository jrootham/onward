class NarrowPostSecondary
  include Interactor

  def call
    context.pathway[:post_secondary] = select_post_secondary
  end

  private

  def select_post_secondary
    return unless context.pathway[:occupation].present? || context.query_params[:ouac_codes].present?

    if context.query_params[:ouac_codes].present?
      ouac_codes = context.query_params[:ouac_codes]
      narrow_by_ouac_codes(ouac_codes)
    elsif context.pathway[:occupation].present?
      ouac_codes = ouac_codes_from_occupations
      narrow_by_ouac_codes(ouac_codes)
    end
  end

  def ouac_codes_from_occupations
    noc_codes = context.pathway[:occupation].map(&:noc_code)
    cip_program_codes = SpecificProgram.where(noc_code: noc_codes).pluck(:cip_program_code)
    top_codes = cip_program_codes.map { |code| code.split('.')[0] }
    ouac_cat_codes = OuacProgramCategory.where(ouac_top_code: top_codes).pluck(:ouac_cat_code).uniq
    OuacProgramCategoryMap.where(ouac_cat_code: ouac_cat_codes).pluck(:ouac_program_code).uniq
  end

  def narrow_by_ouac_codes(ouac_codes)
    OuacUniversityProgram.where(ouac_program_code: ouac_codes)
  end
end