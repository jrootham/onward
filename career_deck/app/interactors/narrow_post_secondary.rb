class NarrowPostSecondary
  include Interactor

   VALID_PARAMS = [:ouac_codes, :uni_codes, :maesd_codes]

  def call
    context.pathway[:post_secondary] = select_post_secondary
  end

  private

  def select_post_secondary
    valid_params = valid_params = VALID_PARAMS.any? { |param| context.query_params[param].present? }
    return unless context.pathway[:occupation].present? || valid_params

    collection = OuacUniversityProgram.includes(:maesd_programs).all

    if context.query_params[:ouac_codes].present?
      return collection.where(ouac_program_code: context.query_params[:ouac_codes])
    end

    if context.pathway[:uni_codes].present?
      return collection.where(ouac_univ_code: context.pathway[:uni_codes])
    end

    if context.pathway[:occupation].present?
      ouac_ids = context.pathway[:occupation].map(&:ouac_university_programs).flatten.uniq.take(50).pluck(:id)
      return collection.where(id: ouac_ids)
    end

    if context.query_params[:maesd_codes].present?
      return collection.where(maesd_programs_ouac_university_programs: { maesd_program_id: context.pathway[:maesd_codes] })
    end

    collection.limit(10)
  end
end