class PathwaysController < ApplicationController
  def index
    @pathway = {}

    empty_pathway = Hash[Pathway::LEVELS.map{ |level| [level, []] }].with_indifferent_access
    query_params = {
      current_level: pathway_params[:current_level],
      maesd_codes: pathway_params[:maesd_codes],
      hs_courses: parse_hs_courses
    }.with_indifferent_access

    context = GeneratePathway.call(query_params: query_params,
                                   pathway: empty_pathway)
    if context.success?
      @pathway = context.pathway
    else
      raise "Unable to generate pathway: #{context.message}"
    end
  end

  def parse_hs_courses
    pathway_params[:hs_courses].split(',')
  end


  def pathway_params
    params.permit(:current_level, :maesd_codes, :search_params, :hs_courses)
  end
end
