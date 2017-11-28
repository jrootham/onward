class OuacTopCategory < ApplicationRecord
  self.table_name = 'ouac_top_category'

  belongs_to :ouac_program_category, foreign_key: 'ouac_top_code'
  has_many :ouac_maesd_maps, foreign_key: 'ouac_top_code', primary_key: 'ouac_top_code'
  has_many :maesd_programs, through: :ouac_maesd_maps
end
