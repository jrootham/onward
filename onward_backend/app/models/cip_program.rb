class CipProgram < ApplicationRecord
  self.table_name = 'cip_codes'

  belongs_to :cip_category, foreign_key: 'cip_top_code'
  belongs_to :specific_program, foreign_key: 'cip_program_code'
end
