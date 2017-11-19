class CipCategory < ApplicationRecord
  self.table_name = 'cip_top_level'

  has_many :cip_programs, foreign_key: 'cip_top_code'
end
