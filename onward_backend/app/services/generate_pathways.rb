class GeneratePathways
  def initialize(query)
    @query = query
  end

  def call
    hs_course_codes = @query[:hs_courses].split(',')
    initial_pathway = Pathway.new(hs_course_codes: hs_course_codes, current_level: @query[:current_level])
    { result: initial_pathway.to_json }
  end
end
