class OuacMaesdMap < ApplicationRecord
  self.table_name = 'program_ouac_map'
  self.primary_key = 'ouac_top_code'

  belongs_to :ouac_top_category, foreign_key: 'ouac_top_code'
  has_one :maesd_program, foreign_key: 'program_code', primary_key: 'program_code'
end
