class PopulateOccupation
  include Interactor

  def call
    return if context.pathway[:occupation].present? && context.pathway[:occupation].length > 0

    post_secondary_programs = context.pathway[:post_secondary]

    context.pathway[:occupation] = related_occupations(post_secondary_programs)
  end

  private

  def related_occupations(post_secondary_programs)
    maesd_programs = post_secondary_programs.map(&:maesd_programs).flatten
    maesd_programs.map(&:occupations).flatten
  end
end