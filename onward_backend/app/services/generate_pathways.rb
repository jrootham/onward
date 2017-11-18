class GeneratePathways
  def initialize(query)
    @query = query
  end

  def call
    initial_pathway = Pathway.new(@query[:hs_courses])


  end
end
