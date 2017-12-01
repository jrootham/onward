class NarrowOccupation
  include Interactor

  VALID_PARAMS = [:noc_codes, :salary, :maesd_codes]

  def call
    context.pathway[:occupation] = select_occupations
  end

  private

  def select_occupations
    valid_params = VALID_PARAMS.any? { |param| context.query_params[param].present? }
    return unless valid_params

    collection = Occupation.includes(:maesd_programs, :ouac_university_programs).all

    if context.query_params[:maesd_codes]
      collection = collection.where(univ_programs_maesd: { program_code: context.query_params[:maesd_codes] })
    end

    if context.query_params[:noc_codes]
      return collection.where(noc_code: context.query_params[:noc_codes])
    end

    if context.query_params[:salary]
      collection = collection.where('salary >= ?', context.query_params[:salary])
    end

    collection.limit(50)
  end
end