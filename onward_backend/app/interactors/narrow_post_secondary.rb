class NarrowPostSecondary
  include Interactor

   VALID_PARAMS = [:ouac_codes, :uni_codes]

  def call
    context.pathway[:post_secondary] = select_post_secondary
  end

  private

  def select_post_secondary
    valid_params = valid_params = VALID_PARAMS.any? { |param| context.query_params[param].present? }
    return unless context.pathway[:occupation].present? || valid_params

    collection = OuacUniversityProgram.all

    if context.query_params[:ouac_codes].present?
      collection.where(ouac_program_code: context.query_params[:ouac_codes])
    end

    if context.query_params[:uni_codes].present?
      collection.where(ouac_univ_code: context.query_params[:uni_codes])
    end

    if context.pathway[:occupation].present?
      ouac_codes = ouac_codes_from_occupations
      collection.where(ouac_program_code: ouac_codes)
    end

    collection
  end

  def ouac_codes_from_occupations
    noc_codes = context.pathway[:occupation].pluck(:noc_code)
    cip_program_codes = SpecificProgram.where(noc_code: noc_codes).pluck(:cip_program_code)
    top_codes = cip_program_codes.map { |code| code.split('.')[0] }
    ouac_cat_codes = OuacProgramCategory.where(ouac_top_code: top_codes).pluck(:ouac_cat_code).uniq
    OuacProgramCategoryMap.where(ouac_cat_code: ouac_cat_codes).pluck(:ouac_program_code).uniq
  end
end