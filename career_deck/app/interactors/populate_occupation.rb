class PopulateOccupation
  include Interactor

  def call
    return if context.pathway[:occupation].present? && context.pathway[:occupation].count > 0

    post_secondary_programs = context.pathway[:post_secondary]

    context.pathway[:occupation] = related_occupations(post_secondary_programs)
  end

  private

  def related_occupations(post_secondary_programs)
    post_secondary_programs.map(&:occupations).limit(2).flatten
  end
end