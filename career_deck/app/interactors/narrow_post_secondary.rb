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

    collection = OuacUniversityProgram.includes(:occupations).all

    if context.query_params[:ouac_codes].present?
      collection.where(ouac_program_code: context.query_params[:ouac_codes])
    end

    if context.query_params[:uni_codes].present?
      collection.where(ouac_univ_code: context.query_params[:uni_codes])
    end

    if context.pathway[:occupation].present?
      ouac_codes = ouac_codes_from_occupation
      collection.where(ouac_program_code: ouac_codes)
    end

    collection
  end

  def ouac_codes_from_occupation
    context.pathway[:occupation].map(&:ouac_university_programs).flatten.take(10).pluck(:id)
  end
end