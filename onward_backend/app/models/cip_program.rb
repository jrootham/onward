class CipProgram < ApplicationRecord
  self.table_name = 'cip_codes'

  belongs_to :cip_category, foreign_key: 'cip_top_code'
end
