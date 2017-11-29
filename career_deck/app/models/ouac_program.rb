class OuacProgram < ApplicationRecord
  self.table_name = 'ouac_programs'
  has_many :ouac_program_category_maps, foreign_key: 'ouac_program_code'
  has_many :ouac_program_categories, through: :ouac_program_category_maps
end
