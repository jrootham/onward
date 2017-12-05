class PopulateOccupation
  include Interactor

  OCC_PARAMS = [:noc_codes, :salary, :maesd_codes]

  def call
    if OCC_PARAMS.any? { |param| context.query_params[param].present? }
      filter_related_occupations
    else
      populate_related_occupations
    end

  rescue => e
    context.fail! message: "Error populating occupations: #{e}"
  end

  private

  def populate_related_occupations
    context.pathway[:occupation] = context.pathway[:post_secondary].map(&:occupations).limit(2).flatten
  end

  def filter_related_occupations
    occupation_ids = context.pathway[:occupation].pluck(:id)
    ouac_program_ids = context.pathway[:post_secondary].pluck(:id)
    raw_sql = "SELECT DISTINCT `occupations`.`id` FROM `occupations` " +
    "INNER JOIN `maesd_programs_occupations` " +
    "ON `maesd_programs_occupations`.`occupation_id` = `occupations`.`id` " +
    "INNER JOIN `univ_programs_maesd` " +
    "ON `univ_programs_maesd`.`program_code` = `maesd_programs_occupations`.`maesd_program_id` " +
    "INNER JOIN `maesd_programs_ouac_university_programs` " +
    "ON `maesd_programs_ouac_university_programs`.`maesd_program_id` = `univ_programs_maesd`.`program_code` " +
    "WHERE `maesd_programs_ouac_university_programs`.`ouac_university_program_id` " +
    "IN (#{ouac_program_ids.join(',')}) " +
    "AND `occupations`.`id` IN (#{occupation_ids.join(',')})"

    result = ActiveRecord::Base.connection.execute(raw_sql)
    ids = result.to_a.flatten

    context.pathway[:occupation] = Occupation.find(ids)
  end
end


