class OuacProgramCategory < ApplicationRecord
  self.table_name = 'ouac_sub_categories'

  belongs_to :ouac_program_category_map, foreign_key: 'ouac_cat_code'
  has_one :ouac_top_category, foreign_key: 'ouac_top_code', primary_key: 'ouac_top_code'
end
