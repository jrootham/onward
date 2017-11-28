class NarrowOccupation
  include Interactor

  def call
    context.pathway[:occupation] = select_occupations
  end

  private

  def select_occupations
    return unless context.query_params[:noc_codes].present? || context.query_params[:salary].present?
    collection = Occupation.all

    if context.query_params[:noc_codes]
      collection = collection.where(noc_code: context.query_params[:noc_codes])
    end

    if context.query_params[:salary]
      collection = collection.where('salary >= ?', context.query_params[:salary])
    end

    collection
  end
end