class PopulateOccupation
  include Interactor

  OCC_PARAMS = [:noc_codes, :salary, :maesd_codes]

  def call
    return if OCC_PARAMS.any? { |param| context.query_params[param].present? }

    context.pathway[:occupation] = populate_related_occupations

  rescue => e
    context.fail! message: "Error populating occupations: #{e}"
  end

  private

  def populate_related_occupations
    context.pathway[:post_secondary].map(&:occupations).limit(2).flatten
  end
end