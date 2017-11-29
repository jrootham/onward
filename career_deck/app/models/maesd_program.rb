class MaesdProgram < ApplicationRecord
  self.table_name = 'univ_programs_maesd'

  belongs_to :ouac_maesd_map
  belongs_to :cip_maesd_map

  has_and_belongs_to_many :ouac_university_programs
  has_and_belongs_to_many :occupations

  def occupations
    cip_top_codes = CipMaesdMap.where(program_code: program_code).pluck(:cip_top_code).uniq
    cip_program_codes = CipProgram.where(cip_top_code: cip_top_codes).pluck(:cip_program_code)
    noc_codes = SpecificProgram.where(cip_program_code: cip_program_codes).pluck(:noc_code)
    Occupation.where(noc_code: noc_codes)
  end

  def ouac_university_programs
    top_cat_codes = OuacMaesdMap.where(program_code: program_code).pluck(:ouac_top_code).uniq
    cat_codes = OuacProgramCategoryMap.where(ouac_top_code: top_cat_codes).pluck(:ouac_cat_code).uniq
    ouac_codes = OuacProgramCategory.find(cat_codes).pluck(:ouac_program_code).uniq
    OuacUniversityProgram.where(ouac_program_code: ouac_codes)
  end
end
