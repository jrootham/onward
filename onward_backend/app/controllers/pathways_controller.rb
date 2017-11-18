class PathwaysController < ApplicationController
  def index
    service = Services::GeneratePathways.new pathways_params
    result = service.call
    return result[:error].to_json if result[:error]
    return result[:pathways]
  end

  def pathways_params
    params.permit(:hs_courses, :hs_year, :univ_programs)
  end
end
