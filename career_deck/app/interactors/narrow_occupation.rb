class NarrowOccupation
  include Interactor

  VALID_PARAMS = [:noc_codes, :salary, :maesd_codes]

  def call
    select_occupations

  rescue => e
    context.fail! message: "Error selecting occupations: #{e}"
  end

  private

  def select_occupations
    VALID_PARAMS.each do |param|
      if context.query_params[param].present?
        occupations = context.pathway[:occupation].empty? ? Occupation.includes(:maesd_programs) : context.pathway[:occupation]
        send("select_by_#{param}", occupations)
      end
    end
  end

  def select_by_noc_codes(occupations)
    context.pathway[:occupation] = occupations.where(noc_code: context.query_params[:noc_codes])
  end

  def select_by_salary(occupations)
    context.pathway[:occupation] = occupations.where('salary >= ?', context.query_params[:salary])
  end

  def select_by_maesd_codes(occupations)
    context.pathway[:occupation] = occupations.where(univ_programs_maesd: { program_code: context.query_params[:maesd_codes] })
  end
end