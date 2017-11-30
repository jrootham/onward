class Pathway
  attr_accessor :result

  PERMITTED_QUERY_PARAMS = %w(hs_courses current_level cip_codes noc_codes salary ouac_codes maesd_codes)

  LEVELS = %w(grade_9 grade_10 grade_11 grade_12 post_secondary occupation)
end
