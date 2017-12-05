class SelectInOrder
  include Interactor

  VALID_PARAMS = [:noc_codes, :salary, :maesd_codes]

  def call
    PRIORITIZED_PARAMS.each do |param|
      send("select_by_#{param}") if context.query_params[param].present?
    end
  end

  private

  def select_by_noc_codes
    context.pathway[:occupation] = Occupation.where(noc_code: context.query_params[:noc_codes])
  end


  def select_occupations
    valid_params = VALID_PARAMS.any? { |param| context.query_params[param].present? }
    return unless valid_params

    collection = Occupation.includes(:maesd_programs)

    if context.query_params[:noc_codes]
      return collection.where(noc_code: context.query_params[:noc_codes])
    end

    if context.query_params[:maesd_codes]
      collection = collection.where(univ_programs_maesd: { program_code: context.query_params[:maesd_codes] })
    end

    if context.query_params[:salary]
      collection = collection.where('salary >= ?', context.query_params[:salary])
    end

    collection
  end

  def build_pathway(level_to_build)
    result = SelectOccupation
  end
end