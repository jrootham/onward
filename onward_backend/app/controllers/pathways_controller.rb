class PathwaysController < ApplicationController
  def index
    service = GeneratePathways.new pathways_params
    result = service.call

    render json: result[:error].to_json if result[:error]
    render json: result[:result]
  end

  def pathways_params
    params.permit(:hs_courses, :current_level, :noc_codes, :cip_codes)
  end
end
