class GeneratePathways
  def initialize(query)
    @pathway_params = parse_query_params(query)
    p @pathway_params
  end

  def call
    initial_pathway = Pathway.new(@pathway_params)
    { result: initial_pathway.to_json }
  end

  def parse_query_params(query)
    {}.tap do |parsed_query|
      Pathway::PERMITTED_QUERY_PARAMS.each do |pp|
        parsed_query[pp.to_sym] = send("parse_#{pp}", query[pp]) if query[pp].present?
      end
    end
  end

  def parse_hs_courses(value)
    value.split(',')
  end

  def parse_noc_codes(value)
    value.split(',')
  end

  def parse_current_level(value)
    value
  end

  def parse_cip_codes(value)
    value.split(',')
  end
end
