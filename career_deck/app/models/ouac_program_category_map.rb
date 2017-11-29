class OuacProgramCategoryMap < ApplicationRecord
  self.table_name = 'ouac_program_cat_map'
  self.primary_keys = :ouac_program_code, :ouac_cat_code

  belongs_to :ouac_program, foreign_key: 'ouac_program_code'
  has_one :ouac_program_category, foreign_key: 'ouac_cat_code', primary_key: 'ouac_cat_code'
end
